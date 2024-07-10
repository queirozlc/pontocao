defmodule PontoCaoWeb.UserJSON do
  alias PontoCao.Users.User

  @doc """
  Renders a user into a JSON response.
  """
  def render("index.json", %{data: users}) do
    %{data: for(user <- users, do: complete_data(user))}
  end

  def render("show.json", %{data: user}) do
    %{data: complete_data(user)}
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
      role: user.role
    }
  end
end
