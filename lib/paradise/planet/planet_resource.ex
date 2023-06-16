defmodule Paradise.PlanetResource do
  use TypedStruct

  typedstruct opaque: true do
    field :id, String.t(), enforce: true
    field :name, String.t(), enforce: true
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(args) do
    struct!(__MODULE__, args)
  end
end
