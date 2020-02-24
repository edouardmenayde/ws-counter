defmodule CruncherTest do
  use ExUnit.Case
  doctest Cruncher

  test "greets the world" do
    assert Cruncher.hello() == :world
  end
end
