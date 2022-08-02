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

  describe "handle_call/2" do
    test "responds to :dojo msg returning the current dojo state", %{
      initial_audience: initial_audience,
      dojo_pid: pid
    } do
      %Lecabot.Dojo{audience: audience} = GenServer.call(pid, :dojo)

      assert initial_audience == audience
    end
  end

  describe "handle_cast/2" do
    test "responds to {:add_participant, \"username2\"} adding the username to audience", %{
      initial_audience: initial_audience,
      dojo_pid: pid
    } do
      GenServer.cast(pid, {:add_participant, "username2"})

      %Lecabot.Dojo{audience: changed_audience} = GenServer.call(pid, :dojo)
      expected_audience = MapSet.put(initial_audience, "username2")

      assert expected_audience == changed_audience
    end

    test "when adding participant avoids duplicates", %{
      initial_audience: initial_audience,
      dojo_pid: pid
    } do
      :ok = GenServer.cast(pid, {:add_participant, "username"})

      %Lecabot.Dojo{audience: retrieved_audience} = GenServer.call(pid, :dojo)

      assert initial_audience == retrieved_audience
    end

    test "responds to anything else doing nothing", %{
      initial_audience: initial_audience,
      dojo_pid: pid
    } do
      GenServer.cast(pid, :whatever)

      %Lecabot.Dojo{audience: current_state} = GenServer.call(pid, :dojo)

      assert initial_audience == current_state
    end
  end
end
