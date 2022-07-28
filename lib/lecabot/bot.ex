defmodule Lecabot.Bot do
  use TMI

  @impl TMI.Handler
  def handle_message(msg, sender, chat, tags) do
    IO.inspect(%{sender: sender, msg: msg, chat: chat, tags: tags})
  end

  def handle_message("!participar", sender, _chat) do
    add_participant(sender)
  end

  def handle_message("!participantes", _sender, _chat) do
    %Lecabot.Dojo{audience: audience} = GenServer.call(Lecabot.Dojo, :dojo)

    participantes =
      audience
      |> Enum.join(", ")

    say("lecaduco", "Os participantes do Dojo serão: #{participantes}")
  end

  def handle_message(msg, "lecaduco", _chat) do
    IO.puts "Eu disse: #{msg}"
  end

  def handle_message(msg, sender, _chat) do
    cond do
      msg =~ ~r/.*!participar.*/ ->
        add_participant(sender)

      true ->
        IO.puts "vida que segue"
        IO.puts "#{sender} disse: #{msg}"
    end
  end

  def handle_join(channel, user) do
    IO.inspect("#{user} joins #{channel}")
  end

  defp add_participant(sender) do
    IO.puts "#{sender} vai participar!"
    GenServer.cast(Lecabot.Dojo, {:add_participant, sender})
  end
end
