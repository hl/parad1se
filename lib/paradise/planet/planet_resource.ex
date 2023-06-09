defmodule Paradise.PlanetResource do
  use TypedStruct

  typedstruct opaque: true do
    field :name, String.t(), enforce: true
    field :quantity, non_neg_integer(), enforce: true
    field :interval, non_neg_integer(), enforce: true
    field :total, non_neg_integer(), enforce: true
  end
end
