defmodule Paradise.PlanetStorage do
  use GenServer

  alias ETS.KeyValueSet

  @opts Application.compile_env(:paradise, __MODULE__)

  # Client

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @spec get!(term()) :: term()
  def get!(key) do
    set = KeyValueSet.wrap_existing!(@opts[:name])
    KeyValueSet.get!(set, key)
  end

  @spec put(term(), term()) :: :ok
  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  # Server

  @impl GenServer
  def init(_init_arg) do
    set = KeyValueSet.new!(@opts)
    {:ok, set}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, set) do
    KeyValueSet.put(set, key, value)
    {:noreply, set}
  end
end
