defmodule PontoCaoWeb.SessionControllerTest do
  use PontoCaoWeb.ConnCase
  alias PontoCao.{Repo, Users.User}

  @password "secret1234"

  setup do
    user =
      %User{}
      |> User.changeset(%{
        email: "test@example.com",
        password: @password,
        password_confirmation: @password
      })
      |> Repo.insert!()

    {:ok, user: user}
  end

  describe "create/2" do
    @valid_params %{"user" => %{"email" => "test@example.com", "password" => @password}}
    @invalid_params %{"user" => %{"email" => "test@example.com", "password" => "invalid"}}

    test "with valid params", %{conn: conn} do
      conn = post(conn, ~p"/api/session", @valid_params)
      assert json = json_response(conn, 200)
      assert json["data"]["access_token"]
      assert json["data"]["renewal_token"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, ~p"/api/session", @invalid_params)

      assert json = json_response(conn, 401)
      assert json["error"]["message"] == "Invalid email or password"
      assert json["error"]["status"] == 401
    end
  end

  describe "renew/2" do
    setup %{conn: conn} do
      authed_conn = post(conn, ~p"/api/session", @valid_params)

      {:ok, renewal_token: authed_conn.private[:api_renewal_token]}
    end

    test "with valid authorization header", %{conn: conn, renewal_token: token} do
      conn =
        conn
        |> put_req_header("authorization", token)
        |> post(~p"/api/session/renew")

      assert json = json_response(conn, 200)
      assert json["data"]["access_token"]
      assert json["data"]["renewal_token"]
    end

    test "with invalid authorization header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "invalid")
        |> post(~p"/api/session/renew")

      assert json = json_response(conn, 401)
      assert json["error"]["message"] == "Invalid token"
      assert json["error"]["status"] == 401
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      authed_conn = post(conn, ~p"/api/session/", @valid_params)

      {:ok, access_token: authed_conn.private[:api_access_token]}
    end

    test "invalidates", %{conn: conn, access_token: token} do
      conn =
        conn
        |> put_req_header("authorization", token)
        |> delete(~p"/api/session/")

      assert conn.status == 204
    end
  end
end
