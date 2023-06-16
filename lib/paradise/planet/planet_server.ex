defmodule Paradise.PlanetServer do
  @moduledoc """
  Planet Server
  """

  use GenServer

  alias Paradise.PlanetState
  alias Paradise.PlanetStorage
  alias Paradise.Registry
  alias Paradise.Repo

  require Logger

  @spec persist_state(PlanetState.id()) :: :ok
  def persist_state(planet_id) do
    Logger.info("Persisting state #{planet_id}")

    state = PlanetStorage.get!(planet_id)
    Repo.put(planet_id, state)
  end

  # Client

  @spec child_spec([{:planet_id, PlanetState.id()}]) :: Supervisor.child_spec()
  def child_spec(opts) do
    planet_id = Keyword.fetch!(opts, :planet_id)

    %{
      id: "#{__MODULE__}_#{planet_id}",
      start: {__MODULE__, :start_link, [planet_id]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  @spec start_link(PlanetState.id()) :: GenServer.on_start()
  def start_link(planet_id) do
    name = Registry.via_tuple(planet_id)

    case GenServer.start_link(__MODULE__, planet_id, name: name) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  # Server

  @impl GenServer
  def init(planet_id) do
    Process.flag(:trap_exit, true)

    {:ok, planet_id, {:continue, :setup}}
  end

  @impl GenServer
  def handle_continue(:setup, planet_id) do
    state = Repo.get!(planet_id)
    PlanetStorage.put(planet_id, state)

    {:noreply, planet_id}
  end

  def handle_continue(:persist_state, planet_id) do
    persist_state(planet_id)
    {:noreply, planet_id}
  end

  @impl GenServer
  def terminate(reason, planet_id) do
    persist_state(planet_id)
    reason
  end
end
