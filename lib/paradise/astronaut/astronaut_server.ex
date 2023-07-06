defmodule Paradise.AstronautServer do
  @moduledoc """
  Astronaut Server
  """

  use GenServer

  alias Paradise.AstronautState
  alias Paradise.AstronautStorage
  alias Paradise.Repo

  require Logger

  @checks_interval :timer.seconds(1)

  @spec persist_state(AstronautState.id()) :: :ok
  def persist_state(astronaut_id) do
    Logger.info("Persisting state #{astronaut_id}")

    state = AstronautStorage.get!(astronaut_id)
    Repo.put(astronaut_id, state)
  end

  # Client

  @spec child_spec([{:astronaut_id, AstronautState.id()}]) :: Supervisor.child_spec()
  def child_spec(opts) do
    astronaut_id = Keyword.fetch!(opts, :astronaut_id)

    %{
      id: "#{__MODULE__}_#{astronaut_id}",
      start: {__MODULE__, :start_link, [astronaut_id]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  @spec start_link(AstronautState.id()) :: GenServer.on_start()
  def start_link(astronaut_id) do
    case GenServer.start_link(__MODULE__, astronaut_id, name: via_tuple(astronaut_id)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  @spec change_name(pid(), String.t()) :: :ok
  def change_name(server, name) when is_pid(server) do
    GenServer.cast(server, {:change_name, name})
  end

  # Server

  @impl GenServer
  def init(astronaut_id) do
    Process.flag(:trap_exit, true)

    {:ok, astronaut_id, {:continue, :setup}}
  end

  @impl GenServer
  def handle_continue(:setup, astronaut_id) do
    state = Repo.get!(astronaut_id)
    AstronautStorage.put(astronaut_id, state)

    schedule_checks(@checks_interval)

    {:noreply, astronaut_id}
  end

  def handle_continue(:persist_state, astronaut_id) do
    persist_state(astronaut_id)
    {:noreply, astronaut_id}
  end

  @impl GenServer
  def handle_info(:checks, astronaut_id) do
    state = AstronautStorage.get!(astronaut_id)
    updated_state = AstronautState.perform_checks(state)

    if AstronautState.changed?(state, updated_state) do
      AstronautStorage.put(astronaut_id, updated_state)
      schedule_checks(@checks_interval)
      {:noreply, astronaut_id, {:continue, :persist_state}}
    else
      schedule_checks(@checks_interval)
      {:noreply, astronaut_id}
    end
  end

  @impl GenServer
  def handle_cast({:change_name, name}, astronaut_id) do
    state = AstronautStorage.get!(astronaut_id)
    updated_state = AstronautState.name(state, name)

    if AstronautState.changed?(state, updated_state) do
      AstronautStorage.put(astronaut_id, updated_state)
      {:noreply, astronaut_id, {:continue, :persist_state}}
    else
      {:noreply, astronaut_id}
    end
  end

  @impl GenServer
  def terminate(reason, astronaut_id) do
    persist_state(astronaut_id)
    reason
  end

  @spec schedule_checks(non_neg_integer()) :: reference()
  def schedule_checks(checks_interval) do
    Process.send_after(self(), :checks, checks_interval)
  end

  @spec via_tuple(String.t()) :: {:via, Registry, {Paradise.Registry, String.t()}}
  def via_tuple(name) do
    {:via, Registry, {Paradise.Registry, name}}
  end
end
