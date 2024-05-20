defmodule PontoCao.AnnouncementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PontoCao.Announcements` context.
  """

  @doc """
  Generate a pet.
  """
  def pet_fixture(attrs \\ %{}) do
    {:ok, pet} =
      attrs
      |> Enum.into(%{
        age: 42,
        bio: "some bio",
        breed: "some breed",
        dewormed: true,
        disability: true,
        gender: :MALE,
        name: "some name",
        neutered: true,
        pedigree: true,
        photos: ["option1", "option2"],
        size: "120.5",
        spayed: true,
        species: "some species",
        weight: "120.5"
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
