defmodule PontoCaoWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias PontoCao.Accounts

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def require_guest_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> put_status(401)
      |> put_view(PontoCaoWeb.ErrorJSON)
      |> render(:"401")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    token = fetch_token(get_req_header(conn, "authorization"))
    user = token && Accounts.get_user_by_session_token(token)
    assign(conn, :current_user, user)
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def ensure_authenticated(conn, _opts) do
    if conn.assigns[:current_user] && conn.assigns[:current_user].is_active do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(PontoCaoWeb.ErrorJSON)
      |> render(:"401")
      |> halt()
    end
  end

  def get_token(user) do
    Accounts.generate_user_session_token(user)
  end

  # Taken from https://github.com/bobbypriambodo/phoenix_token_plug/blob/master/lib/phoenix_token_plug/verify_header.ex
  defp fetch_token([]), do: nil

  defp fetch_token([token | _]) do
    token
    |> String.replace("Token ", "")
    |> String.trim()
  end
end
