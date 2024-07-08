defmodule PontoCaoWeb.EventControllerTest do
  use PontoCaoWeb.ConnCase

  import PontoCao.AnnouncementsFixtures
  import PontoCao.UsersFixtures
  import Pow.Plug, only: [assign_current_user: 3]

  alias PontoCao.Announcements.Event

  @event_timezone "Etc/UTC"

  @create_attrs %{
    description: "some description of random event",
    title: "some title",
    latitude: "90",
    longitude: "120.5",
    photos: ["https://example.com/", "https://example.com/"],
    frequency: 0,
    input_starts_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(1, :hour),
    input_ends_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(4, :hour),
    timezone: @event_timezone
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    latitude: "-90",
    longitude: "-180",
    frequency: 12,
    input_starts_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(1, :hour),
    input_ends_at:
      NaiveDateTime.utc_now() |> NaiveDateTime.add(4, :day) |> NaiveDateTime.add(1, :hour)
  }
  @invalid_attrs %{
    title: nil,
    description: nil,
    latitude: nil,
    longitude: nil,
    photos: nil,
    frequency: nil,
    input_starts_at: nil,
    input_ends_at: nil,
    timezone: nil
  }

  setup %{conn: conn} do
    user = user_fixture()

    authed_conn =
      put_req_header(conn, "accept", "application/json")
      |> assign_current_user(user, [])

    {:ok, conn: authed_conn, user: user}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)

      assert %{"id" => id, "starts_at" => starts_at, "ends_at" => ends_at} =
               json_response(conn, 201)["data"]

      conn =
        build_conn()
        |> assign_current_user(user, [])
        |> get(~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title",
               "description" => "some description of random event",
               "latitude" => "90",
               "longitude" => "120.5",
               "photos" => ["https://example.com/", "https://example.com/"],
               "frequency" => 0,
               "starts_at" => ^starts_at,
               "ends_at" => ^ends_at
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{
      conn: conn,
      event: %Event{id: id} = event,
      user: user
    } do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)

      assert %{"id" => ^id, "starts_at" => starts_at_updated, "ends_at" => ends_at_updated} =
               json_response(conn, 200)["data"]

      conn =
        recycle(conn)
        |> assign_current_user(user, [])
        |> get(~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some updated title",
               "description" => "some updated description",
               "latitude" => "-90",
               "longitude" => "-180",
               "photos" => ["https://example.com/", "https://example.com/"],
               "frequency" => 12,
               "starts_at" => ^starts_at_updated,
               "ends_at" => ^ends_at_updated
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event, user: user} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        conn = recycle(conn) |> assign_current_user(user, [])
        get(conn, ~p"/api/events/#{event}")
      end
    end
  end

  defp create_event(context) do
    event = event_fixture(%{}, context.user)
    %{event: event}
  end
end
