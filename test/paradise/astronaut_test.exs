defmodule Paradise.AstronautTest do
  use ExUnit.Case

  alias Paradise.Astronaut
  alias Paradise.AstronautState
  alias Paradise.Random
  alias Paradise.Repo

  describe "start_server/1" do
    setup do
      astronaut = AstronautState.new(name: Random.String.generate())
      Repo.put(astronaut.id, astronaut)
      [astronaut: astronaut]
    end

    test "start a new server", %{astronaut: astronaut} do
      assert {:ok, _pid} = Astronaut.start_server(astronaut.id)
    end

    test "start a server twice", %{astronaut: astronaut} do
      assert {:ok, _pid} = Astronaut.start_server(astronaut.id)
      assert :ignore = Astronaut.start_server(astronaut.id)
    end
  end

  describe "change_name/2" do
    setup do
      astronaut = AstronautState.new(name: Random.String.generate())
      Repo.put(astronaut.id, astronaut)
      {:ok, _pid} = Astronaut.start_server(astronaut.id)
      [astronaut: astronaut]
    end

    test "change name", %{astronaut: astronaut} do
      new_name = "new_name"

      assert :ok = Astronaut.change_name(astronaut.id, new_name)
    end
  end
end
