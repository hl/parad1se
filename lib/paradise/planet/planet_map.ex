defmodule Paradise.PlanetMap do
  use TypedStruct

  typedstruct opaque: true do
    field :name, String.t()
    field :tiles, [[integer()]]
  end

  def generate(size_x, size_y, type) do
    type
    |> List.duplicate(size_x)
    |> List.duplicate(size_y)
  end

  def update([row | _rows] = map, type, x, y) do
    max_x = Enum.count(row)
    max_y = Enum.count(map)

    if x > -1 and y > -1 and x < max_x and y < max_y do
      update_in(map, [Access.at(y), Access.at(x)], fn _existing_value -> type end)
    else
      {:error, :out_of_bounds}
    end
  end
end
