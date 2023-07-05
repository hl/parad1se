defmodule Paradise.Planet do
  @moduledoc """
  Planet Context
  """

  alias Paradise.PlanetServer
  alias Paradise.PlanetState

  @spec start_server(PlanetState.id()) :: {:ok, pid} | :ignore
  def start_server(planet_id) do
    child_spec = PlanetServer.child_spec(planet_id: planet_id)

    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {Paradise.DynamicSupervisors, self()}},
      child_spec
    )
  end

  @spec stop_server(PlanetState.id()) :: :ok | {:error, :not_found}
  def stop_server(planet_id) do
    pid = whereis_name(planet_id)

    DynamicSupervisor.terminate_child(
      {:via, PartitionSupervisor, {Paradise.DynamicSupervisors, self()}},
      pid
    )
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
