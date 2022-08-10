defmodule Lecabot.Repo do
  use Ecto.Repo,
    otp_app: :lecabot,
    adapter: Ecto.Adapters.Postgres
end
