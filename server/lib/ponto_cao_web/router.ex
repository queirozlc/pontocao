defmodule PontoCaoWeb.Router do
  use PontoCaoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PontoCaoWeb.Auth, otp_app: :ponto_cao
    plug PontoCaoWeb.ReloadUser
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: PontoCaoWeb.Plugs.AuthErrorHandler
  end

  scope "/api", PontoCaoWeb do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create]
    post "/session/renew", SessionController, :renew
  end

  scope "/api", PontoCaoWeb do
    pipe_through [:api, :api_protected]

    resources "/pets", PetController, except: [:new, :edit]
    resources "/events", EventController, except: [:new, :edit]
    resources "/session", SessionController, singleton: true, only: [:delete]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ponto_cao, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PontoCaoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
