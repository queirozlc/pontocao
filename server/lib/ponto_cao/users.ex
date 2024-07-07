defmodule PontoCao.Users do
  alias PontoCao.{Users.User, Repo}

  @moduledoc """
  This module is responsible for managing users at the domain level,
  this means that it contains some specific functionalities decoupled
  from auth and web layers.
  """

  @doc """
  Completes the user profile with the given attributes.
  """
  def complete_profile(user, attrs) do
    user
    |> User.profile_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Sets the user roles with the given attributes.
  """
  def set_roles(user, attrs) do
    user
    |> User.role_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Gets the user by the given id.
  """
  def get!(id), do: Repo.get!(User, id)

  @doc """
  List all users.
  """
  def list_users, do: Repo.all(User)
end
