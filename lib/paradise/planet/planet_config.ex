defmodule Paradise.PlanetConfig do
  alias Paradise.PlanetResource

  @resources [
    PlanetResource.new(
      id: "red_stone",
      name: "Red Stone"
    ),
    PlanetResource.new(
      id: "water",
      name: "Water"
    )
  ]

  def resources, do: @resources
end
