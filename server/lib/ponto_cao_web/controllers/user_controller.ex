defmodule PontoCaoWeb.UserController do
  use PontoCaoWeb, :controller
  alias PontoCao.{Users, Users.User}

  action_fallback PontoCaoWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    conn |> render(:index, data: users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = Pow.Plug.current_user(conn)
    user = Users.get!(id)

    with {:ok, _conn} <- can?(conn, current_user, :update, user),
         {:ok, _conn} <- can_change_roles?(conn, current_user, user, user_params),
         {:ok, %User{} = user_updated} <- Users.update_user(user, user_params) do
      conn |> put_status(200) |> render(:show, data: user_updated)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get!(id)
    conn |> render(:show, data: user)
  end

  def delete(conn, %{"id" => id}) do
    current_user = Pow.Plug.current_user(conn)
    user = Users.get!(id)

    with {:ok, _conn} <- can?(conn, current_user, :delete, user),
         {:ok, _} <- Users.delete_user(user) do
      conn |> send_resp(204, "")
    end
  end

  # Checks if the current user can change the roles of the user.
  # The current user can change the roles of the user if:
  # - the current user is an admin
  # - is the user itself and is not trying to change its own role to admin

  defp can_change_roles?(conn, current_user, user, user_params) do
    role = Map.get(user_params, "role", nil)

    cond do
      Users.is_admin?(current_user) -> {:ok, conn}
      current_user.id == user.id && !is_admin_role?(role) -> {:ok, conn}
      true -> {:error, :not_allowed}
    end
  end

  defp can?(conn, current_user, action, user) when action in [:update, :delete] do
    cond do
      Users.is_admin?(current_user) -> {:ok, conn}
      current_user.id == user.id -> {:ok, conn}
      true -> {:error, :not_allowed}
    end
  end

  defp is_admin_role?("admin"), do: true
  defp is_admin_role?(_), do: false
end
