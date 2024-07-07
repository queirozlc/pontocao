defmodule PontoCaoWeb.RegistrationControllerTest do
  use PontoCaoWeb.ConnCase

  @password "secret1234"

  describe "create/2" do
    @valid_params %{
      "user" => %{
        "email" => "test@example.com",
        "password" => @password,
        "password_confirmation" => @password
      }
    }
    @invalid_params %{
      "user" => %{"email" => "invalid", "password" => @password, "password_confirmation" => ""}
    }

    test "with valid params", %{conn: conn} do
      conn = post(conn, ~p"/api/registration", @valid_params)
      assert json = json_response(conn, 200)
      assert json["data"]["access_token"]
      assert json["data"]["renewal_token"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, ~p"/api/registration", @invalid_params)
      assert json = json_response(conn, 422)
      assert json["errors"]["email"]
      assert json["errors"]["password_confirmation"]
    end
  end
end
