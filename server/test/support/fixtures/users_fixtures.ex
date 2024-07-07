defmodule PontoCao.UsersFixtures do
  alias PontoCao.Users.User

  @moduledoc """
  This module defines test helpers for creating
  entities via the `PontoCao.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some.email#{System.unique_integer([:positive])}@email.com"

  def user_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: "12345678",
        password_confirmation: "12345678",
        roles: ["DONOR"]
      })

    %User{}
    |> User.changeset(attrs)
    |> User.role_changeset(attrs)
    |> PontoCao.Repo.insert!()
  end
end
