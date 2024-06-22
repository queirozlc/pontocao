defmodule PontoCaoWeb.AuthJSON do
  use PontoCaoWeb, :view

  def render("register.json", %{:user => user}) do
    render_one(user, __MODULE__, "created_user.json", as: :user)
  end

  def render("login.json", %{:user => user, :token => token}) do
    %{
      user: render_one(user, __MODULE__, "privileged_user.json", as: :user),
      token: token
    }
  end

  def render("created_user.json", %{user: user}) do
    %{
      email: user.email,
      message: "User created successfully, please confirm your email"
    }
  end

  def render("privileged_user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      avatar: PontoCaoWeb.Uploaders.Avatar.url({user.avatar, user}, :thumb)
    }
  end
end
