defmodule Paradise.Astronaut do
  @moduledoc """
  Astronaut Context
  """

  alias Paradise.AstronautDynamicSupervisors
  alias Paradise.AstronautServer
  alias Paradise.AstronautState
  alias Paradise.AstronautStorage
  alias Paradise.Registry

  @spec start_server(AstronautState.id()) :: {:ok, pid} | :ignore
  def start_server(astronaut_id) do
    child_spec = AstronautServer.child_spec(astronaut_id: astronaut_id)
    AstronautDynamicSupervisors.start_child(child_spec)
  end

  @spec stop_server(AstronautState.id()) :: :ok | {:error, :not_found} | :undefined
  def stop_server(astronaut_id) do
    pid = Registry.whereis_name(astronaut_id)
    AstronautDynamicSupervisors.terminate_child(pid)
  end

  @spec change_name(AstronautState.id(), String.t()) :: :ok | :undefined
  def change_name(astronaut_id, name) do
    pid = Registry.whereis_name(astronaut_id)
    AstronautServer.change_name(pid, name)
  end

  @spec get_name(AstronautState.id()) :: String.t()
  def get_name(astronaut_id) do
    state = AstronautStorage.get!(astronaut_id)
    AstronautState.name(state)
  end
end
