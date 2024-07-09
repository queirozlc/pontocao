defmodule PontoCaoWeb.UserJSON do
  alias PontoCao.Users.User

  @doc """
  Renders a user into a JSON response.
  """
  def render("index.json", %{data: users}) do
    users
    |> Enum.map(&data/1)
  end

  def render("show.json", %{data: user}) do
    complete_data(user)
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      roles: user.roles
    }
  end

  defp complete_data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      bio: user.bio,
      website: user.website,
      social_links: user.social_links,
      phone: user.phone,
      roles: user.roles
    }
  end
end
