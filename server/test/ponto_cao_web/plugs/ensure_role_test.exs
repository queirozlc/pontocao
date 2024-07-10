defmodule PontoCaoWeb.Plugs.EnsureRolesTest do
  use PontoCaoWeb.ConnCase, async: true
  alias PontoCaoWeb.Plugs.EnsureRole

  @opts ~w(donor)a
  @user_adopter %{id: 1, role: :adopter}
  @user_donor %{id: 2, role: :donor}
  @user_admin %{id: 3, role: :admin}
  @otp_app :ponto_cao

  setup do
    conn =
      build_conn()
      |> Plug.Conn.put_private(:plug_session, %{})
      |> Plug.Conn.put_private(:plug_session_fetch, :done)
      |> Pow.Plug.put_config(otp_app: @otp_app)

    {:ok, conn: conn}
  end

  test "call/2 with no user", %{conn: conn} do
    opts = EnsureRole.init(@opts)
    conn = EnsureRole.call(conn, opts)

    assert conn.halted
  end

  test "call/2 with adopter user", %{conn: conn} do
    opts = EnsureRole.init(@opts)

    conn =
      conn
      |> Pow.Plug.assign_current_user(@user_adopter, otp_app: @otp_app)
      |> EnsureRole.call(opts)

    assert conn.halted
  end

  test "call/2 with adopter user and multiple roles", %{conn: conn} do
    opts = EnsureRole.init(~w(adopter donor admin)a)

    conn =
      conn
      |> Pow.Plug.assign_current_user(@user_adopter, otp_app: @otp_app)
      |> EnsureRole.call(opts)

    refute conn.halted
  end

  test "call/2 with donor user", %{conn: conn} do
    opts = EnsureRole.init(@opts)

    conn =
      conn
      |> Pow.Plug.assign_current_user(@user_donor, otp_app: @otp_app)
      |> EnsureRole.call(opts)

    refute conn.halted
  end

  test "call/2 with donor user and multiple roles", %{conn: conn} do
    opts = EnsureRole.init(~w(adopter donor)a)

    conn
    |> Pow.Plug.assign_current_user(@user_donor, otp_app: @otp_app)
    |> EnsureRole.call(opts)

    refute conn.halted
  end

  test "call/2 with admin user", %{conn: conn} do
    opts = EnsureRole.init(:admin)

    conn =
      conn
      |> Pow.Plug.assign_current_user(@user_admin, otp_app: @otp_app)
      |> EnsureRole.call(opts)

    refute conn.halted
  end

  test "call/2 with admin user and multiple roles", %{conn: conn} do
    opts = EnsureRole.init(~w(adopter donor admin)a)

    conn =
      conn
      |> Pow.Plug.assign_current_user(@user_admin, otp_app: @otp_app)
      |> EnsureRole.call(opts)

    refute conn.halted
  end
end
