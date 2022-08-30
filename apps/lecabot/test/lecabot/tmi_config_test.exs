defmodule Lecabot.Twitch.TMIConfigTest do
  alias Lecabot.Twitch.TMIConfig

  use ExUnit.Case

  describe "generate" do
    test "return a TMI bot config struct" do
      assert TMIConfig.generate() == [
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
