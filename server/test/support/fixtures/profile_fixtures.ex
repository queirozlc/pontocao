defmodule PontoCao.ProfileFixtures do
  import PontoCao.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `PontoCao.Profile` context.
  """

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, address} =
      attrs
      |> Enum.into(%{
        city: "some city",
        latitude: "90",
        longitude: "180",
        neighborhood: "some neighborhood",
        number: 42,
        state: "some state",
        street: "some street",
        zip_code: "some zip_code",
        user_id: user.id
      })
      |> PontoCao.Profile.create_address()

    address
  end
end
