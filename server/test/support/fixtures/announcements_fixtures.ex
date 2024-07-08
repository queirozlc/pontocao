defmodule PontoCao.AnnouncementsFixtures do
  import PontoCao.UsersFixtures
  @example_url "https://example.com/"

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
        breed_id: breed.id
      })
      |> PontoCao.Announcements.create_pet(user.id)

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

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}, user \\ nil) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        title: "some title",
        description: "some description of a cool event",
        latitude: "90",
        longitude: "120.5",
        photos: [@example_url, @example_url],
        frequency: 127,
        input_starts_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(1, :day),
        input_ends_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(5, :day),
        timezone: "Etc/UTC"
      })
      |> PontoCao.Announcements.create_event(get_owner_id(user))

    event
  end

  defp get_owner_id(user) when is_nil(user), do: user_fixture().id
  defp get_owner_id(user), do: user.id
end
