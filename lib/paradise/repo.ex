defmodule Paradise.Repo do
  @moduledoc """
  Repository
  """

  alias Paradise.AstronautState
  alias Paradise.PlanetState

  @type id :: AstronautState.id() | PlanetState.id()
  @type record :: AstronautState.t() | PlanetState.t()

  @spec put(id(), record()) :: :ok
  def put(id, state) do
    CubDB.put(__MODULE__, id, state)
  end

  @spec get(id()) :: record() | nil
  def get(id) do
    CubDB.get(__MODULE__, id)
  end

  @spec get!(id()) :: record()
  def get!(id) do
    case get(id) do
      nil -> raise "#{id} not found"
      state -> state
    end
  end
end
