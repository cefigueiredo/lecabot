defmodule Lecabot.DojoTest do
  use ExUnit.Case
  doctest Lecabot.Dojo

  setup do
    initial_audience = MapSet.new(["lecaduco"])
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

  describe "handle_cast/2 {:add_participant, _lecaduco}" do
    test "responds adding the lecaduco to audience", context do
      GenServer.cast(context.dojo_pid, {:add_participant, "lecaduco2"})

      %Lecabot.Dojo{audience: audience} = GenServer.call(context.dojo_pid, :dojo)
      expected_audience = MapSet.put(context.initial_audience, "lecaduco2")

      assert expected_audience == audience
    end

    test "avoids duplicates", context do
      :ok = GenServer.cast(context.dojo_pid, {:add_participant, "lecaduco"})

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

  describe "handle_cast/2 :iterate - when is starting a session" do
    setup [:initial_iterable_session]

    test "draws 1 name from audience to pilot post", context do
      GenServer.cast(context.dojo_pid, :iterate)

      dojo_atual = GenServer.call(context.dojo_pid, :dojo)

      assert Enum.member?(context.initial_audience, dojo_atual.pilot)
      refute Enum.member?(dojo_atual.audience, dojo_atual.pilot)
    end

    test "draws 1 name from audience to copilot post", context do
      GenServer.cast(context.dojo_pid, :iterate)

      dojo_atual = GenServer.call(context.dojo_pid, :dojo)

      assert Enum.member?(context.initial_audience, dojo_atual.copilot)
      refute Enum.member?(dojo_atual.audience, dojo_atual.copilot)
    end
  end

  describe "handle_cast/2 :iterate - when session is in course" do
    setup [:session_in_course]

    test "returns pilot to audience pool", context do
      GenServer.cast(context.dojo_pid, :iterate)

      dojo_atual = GenServer.call(context.dojo_pid, :dojo)

      assert dojo_atual.pilot != context.previous_pilot
      assert Enum.member?(dojo_atual.audience, context.previous_pilot)
    end

    test "elevate current copilot to pilot post", context do
      GenServer.cast(context.dojo_pid, :iterate)

      dojo_atual = GenServer.call(context.dojo_pid, :dojo)

      refute is_nil(dojo_atual.pilot)
      assert dojo_atual.pilot == context.previous_copilot
      assert dojo_atual.copilot != context.previous_copilot
    end

    test "draws 1 name from audience to copilot post", context do
      GenServer.cast(context.dojo_pid, :iterate)

      dojo_atual = GenServer.call(context.dojo_pid, :dojo)

      assert Enum.member?(context.previous_audience, dojo_atual.copilot)
      refute Enum.member?(dojo_atual.audience, dojo_atual.copilot)
      assert Enum.member?(dojo_atual.audience, context.previous_pilot)
    end
  end

  describe "handle_cast/2 :iterate - when audience is fewer than 3 names" do
    setup do
      initial_audience = MapSet.new(["lecaduco1", "lecaduco2"])
      {:ok, dojo_pid} = GenServer.start(Lecabot.Dojo, %Lecabot.Dojo{audience: initial_audience})

      [
        initial_audience: initial_audience,
        dojo_pid: dojo_pid
      ]
    end

    test "does nothing", context do
      GenServer.cast(context.dojo_pid, :iterate)

      dojo_atual = GenServer.call(context.dojo_pid, :dojo)

      assert dojo_atual.audience == context.initial_audience
      assert is_nil(dojo_atual.pilot)
      assert is_nil(dojo_atual.copilot)
    end
  end

  def initial_iterable_session(_context) do
    initial_audience = MapSet.new(["lecaduco1", "lecaduco2", "lecaduco3"])
    {:ok, dojo_pid} = GenServer.start(Lecabot.Dojo, %Lecabot.Dojo{audience: initial_audience})

    [
      initial_audience: initial_audience,
      dojo_pid: dojo_pid
    ]
  end

  def session_in_course(_context) do
    audience = MapSet.new(["lecaduco1", "lecaduco2", "lecaduco3"])

    current_state = %Lecabot.Dojo{
      pilot: "pilot",
      copilot: "copilot",
      audience: audience
    }

    {:ok, dojo_pid} = GenServer.start(Lecabot.Dojo, current_state)

    [
      previous_audience: audience,
      previous_pilot: "pilot",
      previous_copilot: "copilot",
      dojo_pid: dojo_pid
    ]
  end
end
