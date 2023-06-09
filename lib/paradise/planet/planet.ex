defmodule Paradise.Planet do
  use GenServer
  use TypedStruct
  use Puid, chars: :safe32

  alias Paradise.Repo

  typedstruct opaque: true do
    field :id, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :class, atom(), enforce: true
    field :resources, [Paradise.PlanetResource.t()]
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(args) do
    map = Enum.into(args, %{id: generate()})
    struct!(__MODULE__, map)
  end

  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(planet_id) do
    GenServer.start_link(__MODULE__, planet_id, name: via_tuple(planet_id))
  end

  @impl GenServer
  def init(planet_id) do
    {:ok, planet_id, {:continue, :load_state}}
  end

  @impl GenServer
  def handle_continue(:load_state, planet_id) do
    state = Repo.get!(__MODULE__, planet_id)
    {:noreply, state}
  end

  @spec via_tuple(String.t()) :: {:via, Registry, {Paradise.Registry, String.t()}}
  def via_tuple(planet_id) do
    {:via, Registry, {Paradise.Registry, "planet/" <> planet_id}}
  end
end
