defmodule PontoCaoWeb.UserJSON do
  alias PontoCao.Users.User

  @doc """
  Renders a user into a JSON response.
  """
  def render("index.json", %{data: users}) do
    users
    |> Enum.map(&data/1)
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      roles: user.roles
    }
  end
end
