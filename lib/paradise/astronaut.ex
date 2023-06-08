defmodule Paradise.Astronaut do
  use TypedStruct
  use Puid, chars: :safe32

  typedstruct opaque: true do
    field(:id, String.t(), enforce: true)
    field(:name, String.t(), enforce: true)
    field(:credits, non_neg_integer(), default: 0)
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(args) do
    map = Enum.into(args, %{id: generate()})
    struct!(__MODULE__, map)
  end
end
