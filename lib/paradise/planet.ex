defmodule Paradise.Planet do
  @moduledoc """
  Planet Context
  """

  alias Paradise.Registry
  alias Paradise.PlanetServer
  alias Paradise.PlanetState
  alias Paradise.DynamicSupervisors

  @spec start_server(PlanetState.id()) :: {:ok, pid} | :ignore
  def start_server(planet_id) do
    child_spec = PlanetServer.child_spec(planet_id: planet_id)
    DynamicSupervisors.start_child(child_spec)
  end

  @spec stop_server(PlanetState.id()) :: :ok | {:error, :not_found}
  def stop_server(planet_id) do
    pid = Registry.whereis_name(planet_id)
    DynamicSupervisors.terminate_child(pid)
  end
end
