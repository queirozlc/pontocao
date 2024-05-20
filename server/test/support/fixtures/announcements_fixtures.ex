defmodule PontoCao.AnnouncementsFixtures do
  import PontoCao.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `PontoCao.Announcements` context.
  """

  @doc """
  Generate a pet.
  """
  def pet_fixture(attrs \\ %{}) do
    breed = breed_fixture()
    user = user_fixture()

    {:ok, pet} =
      attrs
      |> Enum.into(%{
        name: "some name",
        bio: "some bio",
        age: 42,
        dewormed: true,
        disability: false,
        gender: :MALE,
        neutered: true,
        pedigree: true,
        photos: [
          "https://imgur.com/",
          "https://imgur.com/"
        ],
        size: "120.5",
        spayed: true,
        species: :DOG,
        weight: "120.5",
        breed_id: breed.id,
        owner_id: user.id
      })
      |> PontoCao.Announcements.create_pet()

    pet
  end

  def breed_fixture(attrs \\ %{}) do
    {:ok, breed} =
      attrs
      |> Enum.into(%{
        name: "some name",
        temperaments: ["friendly", "loving"]
      })
      |> PontoCao.Announcements.create_breed()

    breed
  end
end
