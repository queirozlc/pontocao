defmodule PontoCao.Repo do
  use Ecto.Repo,
    otp_app: :ponto_cao,
    adapter: Ecto.Adapters.Postgres
end
