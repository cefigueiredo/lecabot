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

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :lecabot, Lecabot.Repo,
  username: "lecabot",
  password: "lecabot",
  hostname: "localhost",
  database: "lecabot_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lecabot_web, LecabotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "LcYfP0vKlegnkos76Lsp260SpEx+PDipLSW7jvd08du9KSRb0ULfLlh1A3JWQ31F",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :lecabot, Lecabot.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
