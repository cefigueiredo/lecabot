import Config

config :lecabot,
  main_supervisor: DynamicSupervisor,
  dojo_supervisor: Lecabot.DojoSupervisor,
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
