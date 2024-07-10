defmodule PontoCaoWeb.AuthTest do
  use PontoCaoWeb.ConnCase
  doctest PontoCaoWeb.Auth

  alias PontoCaoWeb.{Auth, Endpoint}
  alias PontoCao.{Repo, Users.User}
  alias Plug.Conn

  @pow_config [otp_app: :ponto_cao]

  setup %{conn: conn} do
    conn = %{conn | secret_key_base: Endpoint.config(:secret_key_base)}
    user = Repo.insert!(%User{id: 1, email: "test@example.com", role: :donor})

    {:ok, conn: conn, user: user}
  end

  test "can create, fetch, renew, and delete session", %{conn: conn, user: user} do
    assert {_res_conn, nil} = run(Auth.fetch(conn, @pow_config))

    assert {res_conn, ^user} = run(Auth.create(conn, user, @pow_config))

    assert %{private: %{api_access_token: access_token, api_renewal_token: renewal_token}} =
             res_conn

    assert {_res_conn, nil} =
             run(Auth.fetch(with_auth_header(conn, "invalid"), @pow_config))

    assert {_res_conn, ^user} =
             run(Auth.fetch(with_auth_header(conn, access_token), @pow_config))

    assert {res_conn, ^user} =
             run(Auth.renew(with_auth_header(conn, renewal_token), @pow_config))

    assert %{
             private: %{
               api_access_token: renewed_access_token,
               api_renewal_token: renewed_renewal_token
             }
           } = res_conn

    assert {_res_conn, nil} =
             run(Auth.fetch(with_auth_header(conn, access_token), @pow_config))

    assert {_res_conn, nil} =
             run(Auth.renew(with_auth_header(conn, renewal_token), @pow_config))

    assert {_res_conn, ^user} =
             run(Auth.fetch(with_auth_header(conn, renewed_access_token), @pow_config))

    assert %Conn{} = run(Auth.delete(with_auth_header(conn, "invalid"), @pow_config))

    assert {_res_conn, ^user} =
             run(Auth.fetch(with_auth_header(conn, renewed_access_token), @pow_config))

    assert %Conn{} =
             run(Auth.delete(with_auth_header(conn, renewed_access_token), @pow_config))

    assert {_res_conn, nil} =
             run(Auth.fetch(with_auth_header(conn, renewed_access_token), @pow_config))

    assert {_res_conn, nil} =
             run(Auth.renew(with_auth_header(conn, renewed_renewal_token), @pow_config))
  end

  defp run({conn, value}), do: {run(conn), value}
  defp run(conn), do: Plug.Conn.send_resp(conn, 200, "")
  defp with_auth_header(conn, token), do: Conn.put_req_header(conn, "authorization", token)
end
