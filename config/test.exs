import Config

config :lecabot,
  main_supervisor: Supervisor,
  dojo_supervisor: {ExUnit, :fetch_test_supervisor},
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
