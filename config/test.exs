import Config

config :lecabot,
  bots: [
    [
      bot: Lecabot.Bot,
      user: "lecaduco",
      channels: ["lecaduco"],
      pass: "oauth:TEST",
      capabilities: ["membership", "tags", "commands"],
      debug: true
    ]
  ]
