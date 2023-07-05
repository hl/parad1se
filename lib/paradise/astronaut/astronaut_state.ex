defmodule Paradise.AstronautState do
  use TypedStruct
  use Puid, chars: :safe32, bits: 128

  alias Paradise.AstronautConfig

  require Logger

  @type id :: String.t()
  @type name :: String.t()

  typedstruct opaque: true do
    field :id, id(), enforce: true
    field :name, name(), enforce: true
    field :credits, non_neg_integer(), default: 0
    field :oxygen, integer(), default: 100
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(args) do
    map = Enum.into(args, %{id: "a-" <> generate()})
    struct!(__MODULE__, map)
  end

  @spec changed?(t(), t()) :: boolean()
  def changed?(state, state), do: true
  def changed?(_state, _updated_state), do: false

  @spec id(t()) :: id()
  def id(%__MODULE__{id: id}), do: id

  @spec name(t()) :: name()
  def name(%__MODULE__{name: name}), do: name

  @spec name(t(), String.t()) :: t()
  def name(%__MODULE__{} = state, new_name) do
    %{state | name: new_name}
  end

  @spec perform_checks(t()) :: t()
  def perform_checks(state) do
    state
    |> check_oxygen(AstronautConfig.oxygen_chance())
  end

  @spec check_oxygen(t(), AstronautConfig.oxygen_chance()) :: t()
  def check_oxygen(state, chance) do
    case :rand.uniform(chance) do
      1 ->
        new_oxygen = state.oxygen - 1
        Logger.info("Oxygen level #{new_oxygen}% for #{state.name} with ID #{state.id}")
        %{state | oxygen: new_oxygen}

      _ ->
        state
    end
  end
end
