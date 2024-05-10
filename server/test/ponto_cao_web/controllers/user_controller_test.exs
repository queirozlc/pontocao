defmodule PontoCaoWeb.UserControllerTest do
  use PontoCaoWeb.ConnCase

  import PontoCao.AccountsFixtures

  alias PontoCao.Accounts.User

  @create_attrs %{
    name: "some name",
    email: "some.email@email.com",
    bio: "some bio",
    avatar: "some avatar",
    website: "https://github.com/",
    social_links: ["https://linkedin.com/"]
  }
  @update_attrs %{
    name: "some updated name",
    email: "some.updated.email@email.com",
    bio: "some updated bio",
    avatar: "some updated avatar",
    website: "https://github.com/",
    social_links: ["https://google.com"]
  }
  @invalid_attrs %{
    name: nil,
    email: nil,
    bio: nil,
    avatar: nil,
    website: nil,
    social_links: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "avatar" => "some avatar",
               "bio" => "some bio",
               "email" => "some.email@email.com",
               "name" => "some name",
               "social_links" => ["https://linkedin.com/"],
               "website" => "https://github.com/"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "avatar" => "some updated avatar",
               "bio" => "some updated bio",
               "email" => "some.updated.email@email.com",
               "name" => "some updated name",
               "social_links" => ["https://google.com"],
               "website" => "https://github.com/"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
