defmodule Paradise.Registry do
  @moduledoc """
  Registry helper functions
  """

  @spec via_tuple(String.t()) :: {:via, Registry, {__MODULE__, String.t()}}
  def via_tuple(name) do
    {:via, Registry, {__MODULE__, name}}
  end

  @spec whereis_name(String.t()) :: pid() | :undefined
  def whereis_name(name) do
    with [{pid, _value}] when is_pid(pid) <- Registry.lookup(__MODULE__, name),
         true <- Process.alive?(pid) do
      pid
    else
      _not_found_or_alive -> :undefined
    end
  end
end
