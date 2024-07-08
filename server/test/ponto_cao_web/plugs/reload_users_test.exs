defmodule PontoCaoWeb.ReloadUsersTest do
  alias PontoCaoWeb.ReloadUser
  alias PontoCao.Users
  use PontoCaoWeb.ConnCase, async: true
  import PontoCao.UsersFixtures

  @otp_app :ponto_cao

  setup do
    user = user_fixture()

    conn =
      build_conn()
      |> Pow.Plug.put_config(otp_app: @otp_app)

    {:ok, conn: conn, user: user}
  end

  test "call/2 with no user", %{conn: conn} do
    assert ReloadUser.call(conn, []) == conn
  end

  test "call/2 with user assigned", %{conn: conn, user: user} do
    %Plug.Conn{assigns: %{current_user: current_user}} =
      conn = Pow.Plug.assign_current_user(conn, user, otp_app: @otp_app)

    assert ReloadUser.call(conn, []) == conn
    assert current_user == user
    assert current_user == Users.get!(user.id)
    assert current_user == Pow.Plug.current_user(conn)
  end
end
