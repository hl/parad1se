defmodule Paradise.Astronaut do
  @moduledoc """
  Astronaut Context
  """

  alias Paradise.AstronautServer
  alias Paradise.AstronautState
  alias Paradise.AstronautStorage

  @spec start_server(AstronautState.id()) :: {:ok, pid} | :ignore
  def start_server(astronaut_id) do
    child_spec = AstronautServer.child_spec(astronaut_id: astronaut_id)

    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {Paradise.DynamicSupervisors, self()}},
      child_spec
    )
  end

  @spec stop_server(AstronautState.id()) :: :ok | {:error, :not_found} | :undefined
  def stop_server(astronaut_id) do
    pid = whereis_name(astronaut_id)

    DynamicSupervisor.terminate_child(
      {:via, PartitionSupervisor, {Paradise.DynamicSupervisors, self()}},
      pid
    )
  end

  @spec change_name(AstronautState.id(), String.t()) :: :ok | :undefined
  def change_name(astronaut_id, name) do
    pid = whereis_name(astronaut_id)
    AstronautServer.change_name(pid, name)
  end

  @spec get_name(AstronautState.id()) :: String.t()
  def get_name(astronaut_id) do
    state = AstronautStorage.get!(astronaut_id)
    AstronautState.name(state)
  end

  @spec whereis_name(String.t()) :: pid() | :undefined
  def whereis_name(name) do
    with [{pid, _value}] when is_pid(pid) <- Registry.lookup(Paradise.Registry, name),
         true <- Process.alive?(pid) do
      pid
    else
      _not_found_or_alive -> :undefined
    end
  end
end
