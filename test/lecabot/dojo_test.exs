defmodule Lecabot.DojoTest do
  use ExUnit.Case
  doctest Lecabot.Dojo

  setup do
    initial_audience = MapSet.new(["username"])
    {:ok, dojo_pid} = GenServer.start(Lecabot.Dojo, %Lecabot.Dojo{audience: initial_audience})

    [
      initial_audience: initial_audience,
      dojo_pid: dojo_pid
    ]
  end

  describe "handle_call/2 :dojo" do
    test "responds returning the current dojo state", context do
      %Lecabot.Dojo{audience: audience} = GenServer.call(context.dojo_pid, :dojo)

      assert context.initial_audience == audience
    end
  end

  describe "handle_cast/2 {:add_participant, _username}" do
    test "responds adding the username to audience", context do
      GenServer.cast(context.dojo_pid, {:add_participant, "username2"})

      %Lecabot.Dojo{audience: audience} = GenServer.call(context.dojo_pid, :dojo)
      expected_audience = MapSet.put(context.initial_audience, "username2")

      assert expected_audience == audience
    end

    test "avoids duplicates", context do
      :ok = GenServer.cast(context.dojo_pid, {:add_participant, "username"})

      %Lecabot.Dojo{audience: audience} = GenServer.call(context.dojo_pid, :dojo)

      assert context.initial_audience == audience
    end
  end

  describe "handle_cast/2 when msg is unknown" do
    test "responds doing nothing", context do
      GenServer.cast(context.dojo_pid, :whatever)

      %Lecabot.Dojo{audience: current_state} = GenServer.call(context.dojo_pid, :dojo)

      assert context.initial_audience == current_state
    end
  end

      %Lecabot.Dojo{audience: current_state} = GenServer.call(pid, :dojo)

      assert initial_audience == current_state
    end
  end
end
