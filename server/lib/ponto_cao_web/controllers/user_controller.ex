defmodule PontoCaoWeb.UserController do
  use PontoCaoWeb, :controller
  alias PontoCao.{Users, Users.User}
  alias Plug.Conn

  action_fallback PontoCaoWeb.FallbackController

  @doc """
  Show all users
  """
  def index(conn, _params) do
    users = Users.list_users()
    conn |> render("index.json", data: users)
  end

  @doc """
  Completes the user registration process setting the user's role
  """
  def roles(%Conn{} = conn, %{"user" => user_params}) do
    user = Users.get!(conn.assigns.current_user.id)

    with {:ok, %User{}} <- Users.set_roles(user, user_params) do
      send_resp(conn, :ok, "")
    end
  end
end
