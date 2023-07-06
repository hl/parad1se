defmodule Paradise.PlanetState do
  use TypedStruct
  use Puid, chars: :safe32, bits: 128

  @type id :: String.t()

  typedstruct opaque: true do
    field :id, id(), enforce: true
    field :name, String.t(), enforce: true
    field :class, String.t(), enforce: true
    field :resources, [Paradise.PlanetResource.t()]
    field :map, Paradise.PlanetMap.t()
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(args) do
    map = Enum.into(args, %{id: generate()})
    struct!(__MODULE__, map)
  end

  @spec id(t()) :: id()
  def id(%__MODULE__{id: id}), do: id
end
