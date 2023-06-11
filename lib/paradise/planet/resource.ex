defmodule Paradise.Planet.Resource do
  use TypedStruct

  @typep resource_type :: :

  typedstruct opaque: true do
    field :id, String.t(), enforce: true
    field :type, resource_type(), enforce: true
    field :name, String.t(), enforce: true
    field :quantity, non_neg_integer(), enforce: true
    field :interval, non_neg_integer(), enforce: true
    field :cap, non_neg_integer(), enforce: true
    field :updated_at, NaiveDateTime.t()
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(args) do
    struct!(__MODULE__, args)
  end
end
