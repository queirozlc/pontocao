defmodule PontoCaoWeb.Plugs.EnsureRole do
  @moduledoc """
  This plug ensures that a user has a particular role.

  ## Example

      plug MyAppWeb.EnsureRolePlug, [:user, :admin]

      plug MyAppWeb.EnsureRolePlug, :admin

      plug MyAppWeb.EnsureRolePlug, ~w(user admin)a
  """
  import Plug.Conn, only: [halt: 1]
  use PontoCaoWeb, :verified_routes
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  @doc false
  @spec call(Conn.t(), atom() | binary() | [atom()] | [binary()]) :: Conn.t()
  def call(conn, roles) do
    conn
    |> Plug.current_user()
    |> has_role?(roles)
    |> maybe_halt(conn)
  end

  defp has_role?(nil, _roles), do: false
  defp has_role?(user, roles) when is_list(roles), do: Enum.any?(roles, &has_role?(user, &1))
  defp has_role?(%{role: role}, role) when is_atom(role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn
    |> Conn.send_resp(403, "")
    |> halt()
  end
end
