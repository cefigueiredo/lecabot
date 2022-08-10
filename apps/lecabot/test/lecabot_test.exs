defmodule LecabotTest do
  use ExUnit.Case
  doctest Lecabot

  test "greets the world" do
    assert Lecabot.hello() == :world
  end
end
