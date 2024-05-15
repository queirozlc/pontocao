defmodule PontoCao.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PontoCao.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some.email#{System.unique_integer([:positive])}@email.com"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar: "some avatar",
        bio: "some bio",
        email: unique_user_email(),
        name: "some name",
        social_links: ["https://linkedin.com/", "https://github.com/"],
        website: "https://google.com/",
        phone: "+5527992032080",
        roles: ["ADOPTER"]
      })
      |> PontoCao.Accounts.create_user()

    user
  end
end
