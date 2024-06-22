defmodule PontoCaoWeb.AuthController do
  require Logger
  use PontoCaoWeb, :controller
  alias PontoCao.Accounts
  import PontoCaoWeb.UserAuth

  action_fallback PontoCaoWeb.FallbackController

  def index(conn, _) do
    render(conn, "index.json", user: conn.assigns[:current_user])
  end

  def register(conn, %{"user" => user_params}) do
    with {:ok, %Accounts.User{} = user} <- Accounts.register_user(user_params),
         {:ok, _} <- Accounts.deliver_confirmation_instructions(user, fn token -> "#{token}" end) do
      conn
      |> put_status(:created)
      |> render("register.json", user: user)
    end
  end

  def confirm(conn, %{"token" => token}) do
    with {:ok, _} <- Accounts.confirm_user(token) do
      send_resp(conn, :ok, "")
    end
  end

  def login(conn, %{
        "email" => email,
        "password" => password
      }) do
    if(user = Accounts.get_user_by_email_and_password(email, password)) do
      if(user.is_active) do
        token = get_token(user)
        render(conn, "login.json", user: user, token: token)
      else
        {:error, :bad_request, "User is not active, please confirm your email"}
      end
    else
      {:error, :unauthorized, "Invalid email or password"}
    end
  end
end
