defmodule PontoCaoWeb.ReloadUsersTest do
  use PontoCaoWeb.ConnCase, async: true
  import PontoCao.UsersFixtures

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: conn, user: user}
  end
end
