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
  Gets the user by the given id.
  """
  def get!(id), do: Repo.get!(User, id)

  @doc """
  Updates the user with the given attributes.
  """
  def update_user(user, attrs) do
    user
    |> User.profile_changeset(attrs)
    |> User.role_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the user.
  """
  def delete_user(user), do: Repo.delete(user)

  @doc """
  List all users.
  """
  def list_users, do: Repo.all(User)

  @doc """
  Checks if the user has an admin role.
  """
  def is_admin?(%{role: :admin}), do: true
  def is_admin?(_), do: false
end
