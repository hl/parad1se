defmodule Paradise.Planet do
  use GenServer
  use TypedStruct
  use Puid, chars: :safe32

  alias Paradise.Repo

  typedstruct opaque: true do
    field(:id, String.t(), enforce: true)
    field(:name, String.t(), enforce: true)
  end

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(init_arg) do
    planet_id = Keyword.fetch!(init_arg, :id)
    GenServer.start_link(__MODULE__, init_arg, name: via_tuple(planet_id))
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg, {:continue, :load_state}}
  end

  @impl GenServer
  def handle_continue(:load_state, init_arg) do
    planet_id = Keyword.fetch!(init_arg, :id)

    state =
      case Repo.get(__MODULE__, planet_id) do
        nil -> struct!(__MODULE__, init_arg)
        planet -> planet
      end

    {:noreply, state}
  end

  @spec via_tuple(String.t()) :: {:via, Registry, {Paradise.Registry, String.t()}}
  def via_tuple(planet_id) do
    {:via, Registry, {Paradise.Registry, "planet/" <> planet_id}}
  end
end
