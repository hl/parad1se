defmodule Paradise.Repo do
  @moduledoc """
  CubDB Repo
  """

  @spec put(struct()) :: :ok
  def put(%{__struct__: name, id: id} = struct) do
    CubDB.put(__MODULE__, {name, id}, struct)
  end

  @spec get(module(), String.t()) :: struct() | nil
  def get(name, id) do
    CubDB.get(__MODULE__, {name, id})
  end

  @spec get!(module(), String.t()) :: struct()
  def get!(name, id) do
    get(name, id) || raise "#{name} with #{id} not found"
  end

  @spec find_by(module(), String.t(), any()) :: {:ok, struct()} | :error
  def find_by(name, key, value) do
    __MODULE__
    |> CubDB.select(min_key: {name, nil}, max_key: {name, String.duplicate("z", 30)})
    |> Stream.filter(fn
      {^name, %{^key => ^value}} -> true
      _key_value_tuple -> false
    end)
    |> Stream.take(1)
    |> Enum.fetch(0)
  end
end
