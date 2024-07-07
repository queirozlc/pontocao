defmodule PontoCaoWeb.SessionController do
  alias PontoCaoWeb.Auth
  alias Plug.Conn
  use PontoCaoWeb, :controller

  action_fallback PontoCaoWeb.FallbackController

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, conn} <- Pow.Plug.authenticate_user(conn, user_params) do
      json(conn, %{
        data: %{
          access_token: conn.private.api_access_token,
          renewal_token: conn.private.api_renewal_token
        }
      })
    end
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> Auth.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->
        json(conn, %{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token
          }
        })
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> send_resp(:no_content, "")
  end
end
