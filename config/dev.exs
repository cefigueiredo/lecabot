import Config

config :lecabot,
  bots: [
    [
      bot: Lecabot.Bot,
      user: "lecaduco",
      channels: ["lecaduco"],
      pass: "oauth:" <> System.get_env("TWITCH_TOKEN"),
      capabilities: ["membership", "tags", "commands"],
      debug: true
    ]
  ]
