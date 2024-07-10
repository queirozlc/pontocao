defmodule PontoCaoWeb.UserControllerTest do
  use PontoCaoWeb.ConnCase, async: true
  import PontoCao.UsersFixtures
  import Pow.Plug, only: [assign_current_user: 3]

  setup %{conn: conn} do
    user = user_fixture()

    authed_conn =
      conn
      |> put_req_header("accept", "application/json")
      |> assign_current_user(user, [])

    {:ok, conn: authed_conn, user: user}
  end

  describe "index/2" do
    test "lists all users", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users")

      user_attrs = %{
        "id" => user.id,
        "email" => user.email,
        "role" => Atom.to_string(user.role),
        "bio" => user.bio,
        "name" => user.name,
        "social_links" => user.social_links,
        "phone" => user.phone,
        "website" => user.website
      }

      assert json_response(conn, 200)["data"] == [user_attrs]
    end
  end

  describe "update/2" do
    setup :create_admin

    @valid_params %{
      "name" => "name updated",
      "bio" => "bio updated",
      "website" => "https://google.com/",
      "role" => "adopter",
      "phone" => "11992304293"
    }

    @invalid_params %{
      "name" => nil,
      "bio" => nil,
      "website" => nil,
      "role" => nil,
      "phone" => nil
    }

    @invalid_admin_params %{
      "name" => "name updated",
      "bio" => "bio updated",
      "website" => "https://google.com/",
      "role" => "admin",
      "phone" => "11992304293"
    }

    test "updates a user when the current user is an admin", %{conn: conn, admin: admin} do
      user_to_update = user_fixture()

      conn =
        conn
        |> assign_current_user(admin, [])
        |> put(~p"/api/users/#{user_to_update.id}", user: @valid_params)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = recycle(conn) |> assign_current_user(admin, []) |> get(~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "name" => "name updated",
               "bio" => "bio updated",
               "website" => "https://google.com/",
               "role" => "adopter",
               "phone" => "+5511992304293"
             } = json_response(conn, 200)["data"]
    end

    test "updates a user when the current user is the user itself", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @valid_params)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "name" => "name updated",
               "bio" => "bio updated",
               "website" => "https://google.com/",
               "role" => "adopter",
               "phone" => "+5511992304293"
             } = json_response(conn, 200)["data"]
    end

    test "returns an error when the current user is not the user itself or an admin", %{
      conn: conn
    } do
      user_to_update = user_fixture()

      conn = put(conn, ~p"/api/users/#{user_to_update.id}", user: @valid_params)

      assert json_response(conn, 403)["error"] != %{}
    end

    test "returns an error when the current user is not admin and tries to change his role to admin",
         %{
           conn: conn,
           user: user
         } do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @invalid_admin_params)
      assert json_response(conn, 403)["error"] != %{}
    end

    test "returns an error when the params are invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @invalid_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup :create_admin

    test "deletes a user when the current user is an admin", %{conn: conn, admin: admin} do
      user_to_delete = user_fixture()

      conn =
        conn
        |> assign_current_user(admin, [])
        |> delete(~p"/api/users/#{user_to_delete.id}")

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        conn = recycle(conn) |> assign_current_user(admin, [])
        get(conn, ~p"/api/users/#{user_to_delete}")
      end
    end

    test "deletes a user when the current user is the user itself", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user.id}")

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        conn = recycle(conn) |> assign_current_user(user, [])
        get(conn, ~p"/api/users/#{user.id}")
      end
    end

    test "returns an error when the current user is not an admin", %{conn: conn} do
      user_to_delete = user_fixture()

      conn = delete(conn, ~p"/api/users/#{user_to_delete.id}")

      assert json_response(conn, 403)["error"] != %{}
    end
  end

  describe "show/2" do
    test "shows an user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users/#{user.id}")

      user_attrs = %{
        "id" => user.id,
        "email" => user.email,
        "role" => Atom.to_string(user.role),
        "bio" => user.bio,
        "name" => user.name,
        "social_links" => user.social_links,
        "phone" => user.phone,
        "website" => user.website
      }

      assert json_response(conn, 200)["data"] == user_attrs
    end
  end

  defp create_admin(_) do
    user = user_fixture(role: :admin)
    {:ok, admin: user}
  end
end
