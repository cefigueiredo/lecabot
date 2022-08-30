defmodule Lecabot.Bot do
  use TMI

  alias Lecabot.Dojo

  @impl TMI.Handler
  def handle_message(msg, sender, chat, tags) do
    IO.inspect(%{sender: sender, msg: msg, chat: chat, tags: tags})
  end

  def handle_message("!participar", sender, _chat) do
    add_participant(sender)
  end

  def handle_message("!participantes", _sender, _chat) do
    case dojo_supervisor(:count_children) do
      %{active: 0} ->
        {:ignore, "None dojo session running."}

      _ ->
        %Dojo{audience: audience} = GenServer.call(Dojo, :dojo)

        participantes =
          audience
          |> Enum.join(", ")

        say("lecaduco", "Os participantes do Dojo serão: #{participantes}")
    end
  end

  def handle_message("!createdojo", "lecaduco", _chat) do
    child_spec = Supervisor.child_spec({Dojo, %Dojo{}}, id: Lecabot.Dojo)

    case dojo_supervisor(:start_child, [child_spec]) do
      {:error, _} ->
        {:ignore, "Dojo session is already running"}

      _ ->
        {:ok, "Dojo started successfuly."}
    end
  end

  def handle_message("!createdojo", sender, _chat) do
    {:ignore, "\"#{sender}\" is not allowed to create dojos."}
  end

  def handle_message("!closedojo", "lecaduco", _channel) do
    case dojo_supervisor(:terminate_child, [Lecabot.Dojo]) do
      :ok ->
        say("lecaduco", "Dojo terminado!")

      _ ->
        {:ignore, "None dojo session running"}
    end
  end

  def handle_message("!closedojo", sender, _chat) do
    {:ignore, "\"#{sender}\" is not allowed to finish dojos."}
  end

  def handle_message("!iterate", "lecaduco", _channel) do
    case dojo_supervisor(:count_children) do
      %{active: 0} ->
        {:ignore, "None dojo session running."}

      _ ->
        GenServer.cast(Dojo, :iterate)
        %Dojo{pilot: pilot, copilot: copilot} = GenServer.call(Dojo, :dojo)

        if pilot do
          say("lecaduco", "Jogares da rodada:\n --> PILOTO: #{pilot} \n --> COPILOTO: #{copilot}")
        else
          say("lecaduco", "A rodada nao pode iniciar, faltam jogadores.")
        end
    end
  end

  def handle_message(msg, "lecaduco", _chat) do
    IO.puts("Eu disse: #{msg}")
  end

  def handle_message(msg, sender, _chat) do
    cond do
      msg =~ ~r/.*!participar.*/ ->
        add_participant(sender)

      true ->
        {:ignore, IO.puts("#{sender} disse: #{msg}")}
    end
  end

  def handle_join(channel, user) do
    IO.puts("#{user} joins #{channel}")
  end

  defp fetch_dojo_supervisor do
    case Application.fetch_env(:lecabot, :dojo_supervisor) do
      {:ok, {mod, fun}} ->
        {:ok, supervisor} = apply(mod, fun, [])

        supervisor

      {:ok, mod} ->
        mod
    end
  end

  defp dojo_supervisor(function, args \\ []) do
    main_supervisor_module = Application.fetch_env!(:lecabot, :main_supervisor)
    args = [fetch_dojo_supervisor() | args]

    apply(main_supervisor_module, function, args)
  end

  defp add_participant(sender) do
    case DynamicSupervisor.count_children(fetch_dojo_supervisor()) do
      %{active: 0} ->
        {:ignore, "None dojo session running"}

      _ ->
        IO.puts("#{sender} vai participar!")
        GenServer.cast(Dojo, {:add_participant, sender})
    end
  end
end
