defmodule Lecabot.BotTest do
  use ExUnit.Case

  import Mock

  describe "handle_message/3 !participantes" do
    setup :start_dojo_session

    test "post the list of participants in the chat" do
      with_mock(TMI.MessageServer,
        add_message: fn Lecabot.Bot, "lecaduco", msg ->
          assert msg =~ ~r/username1/
          assert msg =~ ~r/username2/
          assert msg =~ ~r/username3/
        end
      ) do
        Lecabot.Bot.handle_message("!participantes", "tst", "lecaduco")
      end
    end

    test "ignore in the absense of a dojo session" do
      stop_supervised(Lecabot.Dojo)

      response = Lecabot.Bot.handle_message("!participantes", "tst", "tst")

      assert response == {:ignore, "None dojo session running."}
    end
  end

  describe "handle_message/3 !createdojo" do
    setup :start_dojo_session

    test "starts a dojo session if sender is lecaduco" do
      rs = stop_supervised(Lecabot.Dojo)

      response = Lecabot.Bot.handle_message("!createdojo", "lecaduco", "tt")

      assert {:ok, _dojo} = response
    end

    test "ignores if sender is not lecaduco" do
      response = Lecabot.Bot.handle_message("!createdojo", "wrong_user", "tt")

      assert {:ignore, msg} = response
      assert msg == "\"wrong_user\" is not allowed to create dojos."
    end

    test "ignores in the case it already exist a running dojo session" do
      response = Lecabot.Bot.handle_message("!createdojo", "lecaduco", "tt")

      assert {:ignore, "Dojo session is already running"} == response
    end
  end

  def start_dojo_session(_context) do
    dojo = %Lecabot.Dojo{audience: ["username1", "username2", "username3"]}
    supervisor_spec = Supervisor.child_spec({Lecabot.Dojo, dojo}, id: Lecabot.Dojo)
    start_supervised(supervisor_spec, restart: :temporary)

    :ok
  end
end
