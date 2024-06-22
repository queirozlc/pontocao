defmodule PontoCao.Accounts.UserNotifier do
  use Phoenix.Swoosh,
    view: PontoCaoWeb.EmailView

  import Swoosh.Email
  alias PontoCao.Mailer

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, token) do
    new()
    |> from("pontocao@example.com")
    |> to(user.email)
    |> subject("Confirm your account! 🐶 🐾")
    |> render_body("confirmation.html", %{user: user, token: token})
    |> Mailer.deliver()
  end
end
