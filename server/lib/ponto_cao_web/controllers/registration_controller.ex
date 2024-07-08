defmodule PontoCaoWeb.RegistrationController do
  use PontoCaoWeb, :controller
  alias Plug.Conn

  action_fallback PontoCaoWeb.FallbackController

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, _user, conn} <- Pow.Plug.create_user(conn, user_params) do
      conn
      |> json(%{
        data: %{
          access_token: conn.private.api_access_token,
          renewal_token: conn.private.api_renewal_token
        }
      })
    end
  end
end
