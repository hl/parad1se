defmodule Paradise.Planet.Config do
  alias Paradise.Planet.Resource

  @resources [
    Resource.new(
      id: "red_stone",
      name: "Red Stone",
      quantity: 2,
      interval: :timer.seconds(5),
      cap: 200
    ),
    Resource.new(
      id: "water",
      name: "Water",
      quantity: 1,
      interval: :timer.seconds(15),
      cap: 100
    )
  ]
end
