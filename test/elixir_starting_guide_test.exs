defmodule ElixirStartingGuideTest do
  use ExUnit.Case
  doctest ElixirStartingGuide

  test "greets the world" do
    assert ElixirStartingGuide.hello() == :world
  end
end
