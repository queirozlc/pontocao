defmodule PontoCaoWeb.UserController do
  use PontoCaoWeb, :controller

  alias PontoCao.Accounts

  action_fallback PontoCaoWeb.FallbackController

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end
end
