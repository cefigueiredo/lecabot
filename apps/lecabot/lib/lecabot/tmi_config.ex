defmodule Lecabot.TMIConfig do
  @docmodule """
    Reune o que é necessario para gerar configs para bots TMI
  """

  @type tmi_config :: [
          bot: atom(),
          user: String.t(),
          channels: [String.t()],
          pass: String.t(),
          capabilities: [String.t()],
          debug: boolean()
        ]

  @spec generate() :: tmi_config()
  def generate() do
    [
      bot: Lecabot.Bot,
      user: "lecaducoBot",
      channels: ["lecaduco"],
      pass: "oauth:token",
      capabilities: ["membership", "tags", "commands"],
      debug: false
    ]
  end
end
