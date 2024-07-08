defmodule PontoCao.AnnouncementsTest do
  use PontoCao.DataCase

  alias PontoCao.Announcements
  import PontoCao.UsersFixtures

  describe "pets" do
    alias PontoCao.Announcements.Pet
    import PontoCao.AnnouncementsFixtures
    import PontoCao.UsersFixtures

    @invalid_attrs %{
      name: nil,
      size: nil,
      bio: nil,
      photos: nil,
      age: nil,
      gender: nil,
      breed: nil,
      species: nil,
      spayed: nil,
      dewormed: nil,
      neutered: nil,
      disability: nil,
      pedigree: nil,
      weight: nil
    }

    test "list_pets/0 returns all pets" do
      pet = pet_fixture()
      assert Announcements.list_pets() == [pet]
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = pet_fixture()
      assert Announcements.get_pet!(pet.id) == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      owner = user_fixture()
      breed = breed_fixture()

      valid_attrs = %{
        name: "some name",
        size: "120.5",
        bio: "some bio",
        photos: ["https://imgur.com/", "https://imgur.com/"],
        age: 42,
        gender: :MALE,
        species: "DOG",
        dewormed: true,
        neutered: true,
        disability: true,
        pedigree: true,
        weight: "120.5",
        breed_id: breed.id
      }

      assert {:ok, %Pet{} = pet} = Announcements.create_pet(valid_attrs, owner.id)
      assert pet.name == "some name"
      assert pet.size == Decimal.new("120.5")
      assert pet.bio == "some bio"
      assert pet.photos == ["https://imgur.com/", "https://imgur.com/"]
      assert pet.age == 42
      assert pet.gender == :MALE
      assert pet.species == :DOG
      assert pet.dewormed == true
      assert pet.neutered == true
      assert pet.disability == true
      assert pet.pedigree == true
      assert pet.weight == Decimal.new("120.5")
    end

    test "create_pet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Announcements.create_pet(@invalid_attrs)
    end

    test "update_pet/2 with valid data updates the pet" do
      pet = pet_fixture()

      update_attrs = %{
        name: "some updated name",
        size: "456.7",
        bio: "some updated bio",
        photos: [
          "https://imgur.com/some_random_photo.jpg",
          "https://imgur.com/some_random_photo2.png"
        ],
        age: 43,
        gender: :MALE,
        species: :DOG,
        dewormed: false,
        neutered: false,
        disability: false,
        pedigree: false,
        weight: "456.7"
      }

      assert {:ok, %Pet{} = pet} = Announcements.update_pet(pet, update_attrs)
      assert pet.name == "some updated name"
      assert pet.size == Decimal.new("456.7")
      assert pet.bio == "some updated bio"

      assert pet.photos == [
               "https://imgur.com/some_random_photo.jpg",
               "https://imgur.com/some_random_photo2.png"
             ]

      assert pet.age == 43
      assert pet.gender == :MALE
      assert pet.dewormed == false
      assert pet.neutered == false
      assert pet.disability == false
      assert pet.pedigree == false
      assert pet.weight == Decimal.new("456.7")
    end

    test "update_pet/2 with invalid data returns error changeset" do
      pet = pet_fixture()
      assert {:error, %Ecto.Changeset{}} = Announcements.update_pet(pet, @invalid_attrs)
      assert pet == Announcements.get_pet!(pet.id)
    end

    test "delete_pet/1 deletes the pet" do
      pet = pet_fixture()
      assert {:ok, %Pet{}} = Announcements.delete_pet(pet)
      assert_raise Ecto.NoResultsError, fn -> Announcements.get_pet!(pet.id) end
    end

    test "change_pet/1 returns a pet changeset" do
      pet = pet_fixture()
      assert %Ecto.Changeset{} = Announcements.change_pet(pet)
    end
  end

  describe "breeds" do
    test "create_breed/2 with valid data" do
      valid_attrs = %{
        name: "Labrador",
        temperaments: ["outgoing", "even-tempered", "gentle", "agile", "kind", "intelligent"]
      }

      assert {:ok, %PontoCao.Announcements.Breed{} = breed} =
               Announcements.create_breed(valid_attrs)

      assert breed.name == "Labrador"

      assert breed.temperaments == [
               "outgoing",
               "even-tempered",
               "gentle",
               "agile",
               "kind",
               "intelligent"
             ]
    end

    test "create_breed/2 with invalid data" do
      invalid_attrs = %{
        name: nil,
        temperaments: nil
      }

      assert {:error, %Ecto.Changeset{} = error} = Announcements.create_breed(invalid_attrs)

      assert error.errors == [
               name: {"can't be blank", [validation: :required]},
               temperaments: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "events" do
    alias PontoCao.Announcements.Event

    import PontoCao.AnnouncementsFixtures

    @example_url "https://example.com/"

    @invalid_attrs %{
      title: nil,
      description: nil,
      latitude: nil,
      longitude: nil,
      photos: nil,
      frequency: nil,
      owner_id: nil,
      timezone: nil,
      input_starts_at: nil,
      input_ends_at: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()

      # cannot just assert with [event] because input_starts_at and input_ends_at are virtual fields
      # and they are not present in the event struct
      # so we have to assert with the event_fixture() function
      stored_event =
        Map.put(event, :input_starts_at, nil)
        |> Map.put(:input_ends_at, nil)

      assert Announcements.list_events() == [stored_event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture() |> Map.put(:input_starts_at, nil) |> Map.put(:input_ends_at, nil)
      assert Announcements.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      owner = user_fixture()

      valid_attrs = %{
        title: "some title",
        description: "some description of some cool event",
        latitude: "90",
        longitude: "120.5",
        frequency: 127,
        photos: [@example_url, @example_url],
        owner_id: owner.id,
        input_starts_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(1, :day),
        input_ends_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(5, :day),
        timezone: "Etc/UTC"
      }

      assert {:ok, %Event{} = event} = Announcements.create_event(valid_attrs)
      assert event.title == "some title"
      assert event.description == "some description of some cool event"
      assert event.latitude == Decimal.new("90")
      assert event.longitude == Decimal.new("120.5")
      assert event.photos == ["https://example.com/", "https://example.com/"]
      assert event.owner_id == owner.id
      assert event.timezone == "Etc/UTC"
      assert event.original_offset == 0
      assert event.frequency == 127
      # Check if the event starts_at and ends_at regardless seconds are the same
      assert DateTime.truncate(event.starts_at, :second) ==
               DateTime.truncate(DateTime.utc_now() |> DateTime.add(1, :day), :second)

      assert DateTime.truncate(event.ends_at, :second) ==
               DateTime.truncate(DateTime.utc_now() |> DateTime.add(5, :day), :second)
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Announcements.create_event(@invalid_attrs)
    end

    test "create_event/1 with starts_at in the past returns error changeset" do
      owner = user_fixture()

      invalid_attrs = %{
        title: "some title",
        description: "some description of some cool event",
        latitude: "90",
        longitude: "120.5",
        frequency: 127,
        photos: [@example_url, @example_url],
        owner_id: owner.id,
        input_starts_at: ~N[2024-05-01 00:00:00],
        input_ends_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(5, :day),
        timezone: "Etc/UTC"
      }

      assert {:error, %Ecto.Changeset{}} = Announcements.create_event(invalid_attrs)
    end

    test "create_event/1 with ends_at before starts_at returns error changeset" do
      owner = user_fixture()

      invalid_attrs = %{
        title: "some title",
        description: "some description of some cool event",
        latitude: "90",
        longitude: "120.5",
        frequency: 127,
        photos: [@example_url, @example_url],
        owner_id: owner.id,
        input_starts_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(5, :day),
        input_ends_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(1, :day),
        timezone: "Etc/UTC"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Announcements.create_event(invalid_attrs)
      assert changeset.errors == [input_ends_at: {"must be after starts_at", []}]
      assert changeset.valid? == false
    end

    test "create_event/1 with frequency greater than 0 if is a one day event returns error changeset" do
      owner = user_fixture()

      invalid_attrs = %{
        title: "some title",
        description: "some description of some cool event",
        latitude: "90",
        longitude: "120.5",
        frequency: 120,
        photos: [@example_url, @example_url],
        owner_id: owner.id,
        input_starts_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(5, :day),
        input_ends_at:
          NaiveDateTime.utc_now() |> NaiveDateTime.add(5, :day) |> NaiveDateTime.add(1, :hour),
        timezone: "Etc/UTC"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Announcements.create_event(invalid_attrs)
      assert changeset.valid? == false
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        title: "some updated title",
        description: "some updated description",
        latitude: "-90",
        longitude: "-180",
        photos: ["https://imgur.com/", "https://imgur.com/"]
      }

      assert {:ok, %Event{} = event} = Announcements.update_event(event, update_attrs)
      assert event.title == "some updated title"
      assert event.description == "some updated description"
      assert event.latitude == Decimal.new("-90")
      assert event.longitude == Decimal.new("-180")
      assert event.photos == ["https://imgur.com/", "https://imgur.com/"]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Announcements.update_event(event, @invalid_attrs)

      assert event |> Map.put(:input_starts_at, nil) |> Map.put(:input_ends_at, nil) ==
               Announcements.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Announcements.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Announcements.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Announcements.change_event(event)
    end
  end
end
