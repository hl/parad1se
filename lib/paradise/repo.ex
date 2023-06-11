defmodule Paradise.Repo do
  @moduledoc """
  CubDB Repo
  """

  @spec put(struct()) :: :ok
  def put(%{__struct__: name, id: id} = struct) when is_binary(id) do
    CubDB.put(__MODULE__, {name, id}, struct)
  end

  @spec get(atom(), String.t()) :: struct() | nil
  def get(name, id) do
    CubDB.get(__MODULE__, {name, id})
  end

  @spec get!(atom(), String.t()) :: struct()
  def get!(name, id) do
    get(name, id) || raise "#{name} with #{id} not found"
  end
end
