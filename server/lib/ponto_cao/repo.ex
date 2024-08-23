defmodule PontoCao.Repo do
  use EctoHooks.Repo,
    otp_app: :ponto_cao,
    adapter: Ecto.Adapters.Postgres
end
