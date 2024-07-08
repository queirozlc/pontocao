defmodule PontoCaoWeb.EventController do
  use PontoCaoWeb, :controller

  alias PontoCao.{Announcements, Announcements.Event, Users.User}

  action_fallback PontoCaoWeb.FallbackController

  plug PontoCaoWeb.Plugs.EnsureRole, :DONOR when action in [:create, :update, :delete]

  def index(conn, _params) do
    events = Announcements.list_events()
    render(conn, :index, events: events)
  end

  def create(conn, %{"event" => event_params}) do
    %User{id: owner_id} = Pow.Plug.current_user(conn)

    with {:ok, %Event{} = event} <- Announcements.create_event(event_params, owner_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/events/#{event}")
      |> render(:show, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Announcements.get_event!(id)
    render(conn, :show, event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Announcements.get_event!(id)

    with {:ok, _conn} <- check_event_owner(conn, event),
         {:ok, %Event{} = event} <- Announcements.update_event(event, event_params) do
      render(conn, :show, event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Announcements.get_event!(id)

    with {:ok, _conn} <- check_event_owner(conn, event),
         {:ok, %Event{}} <- Announcements.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end

  defp check_event_owner(conn, event) do
    current_user = Pow.Plug.current_user(conn)

    if event.owner_id == current_user.id do
      {:ok, conn}
    else
      conn
      |> put_status(:forbidden)
      |> render(PontoCaoWeb.ErrorJSON, "403.json")
      |> halt()
    end
  end
end
