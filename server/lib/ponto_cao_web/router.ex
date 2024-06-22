defmodule PontoCaoWeb.Router do
  use PontoCaoWeb, :router
  import PontoCaoWeb.UserAuth

  pipeline :api_guest do
    plug :accepts, ["json"]
    plug :fetch_current_user
    plug :require_guest_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_current_user
    plug :ensure_authenticated
  end

  scope "/api", PontoCaoWeb do
    pipe_through :api

    post "/auth/logout", AuthController, :logout
    get "/auth", AuthController, :index
    resources "/users", UserController, except: [:new, :edit]
    resources "/pets", PetController, except: [:new, :edit]
    resources "/events", EventController, except: [:new, :edit]
  end

  scope "/api", PontoCaoWeb do
    pipe_through :api_guest

    scope "/auth" do
      post "/register", AuthController, :register
      post "/login", AuthController, :login
      post "/confirm", AuthController, :confirm
    end
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
