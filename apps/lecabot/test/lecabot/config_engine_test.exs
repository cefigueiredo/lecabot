defmodule Lecabot.ConfigEngineTest do
  alias Lecabot.ConfigEngine

  use ExUnit.Case

  describe "generate" do
    test "return a TMI bot config struct" do
      assert ConfigEngine.generate  == [
        {:bot, Lecabot.Bot},
        {:user, "lecaducoBot"},
        {:channels, ["lecaduco"]},
        {:pass, "oauth:token"},
        {:capabilities, ["membership", "tags", "commands"]},
        {:debug, false}
      ]
    end
  end
end
