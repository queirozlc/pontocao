defmodule PontoCaoWeb.ReloadUser do
  alias PontoCao.Users
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  @doc false
  @spec call(Conn.t(), atom() | binary() | [atom()] | [binary()]) :: Conn.t()
  def call(conn, _opts) do
    config = Plug.fetch_config(conn)

    case Plug.current_user(conn, config) do
      nil ->
        conn

      user ->
        reloaded_user = Users.get!(user.id)
        Plug.assign_current_user(conn, reloaded_user, config)
    end
  end
end
