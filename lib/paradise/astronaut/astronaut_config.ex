defmodule Paradise.AstronautConfig do
  @type oxygen_chance :: non_neg_integer()
  @doc "The chance that the oxygen will be descrease by 1 every 1 second e.g. 1 in 25 chance"
  @spec oxygen_chance() :: oxygen_chance()
  def oxygen_chance, do: 25
end
