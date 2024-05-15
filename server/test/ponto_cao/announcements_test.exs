defmodule PontoCao.AnnouncementsTest do
  use PontoCao.DataCase

  alias PontoCao.Announcements

  describe "pets" do
    alias PontoCao.Announcements.Pet

    import PontoCao.AnnouncementsFixtures

    @invalid_attrs %{name: nil, size: nil, bio: nil, photos: nil, age: nil, gender: nil, breed: nil, species: nil, spayed: nil, dewormed: nil, neutered: nil, disability: nil, pedigree: nil, weight: nil}

    test "list_pets/0 returns all pets" do
      pet = pet_fixture()
      assert Announcements.list_pets() == [pet]
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = pet_fixture()
      assert Announcements.get_pet!(pet.id) == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      valid_attrs = %{name: "some name", size: "120.5", bio: "some bio", photos: ["option1", "option2"], age: 42, gender: :male, breed: "some breed", species: "some species", spayed: true, dewormed: true, neutered: true, disability: true, pedigree: true, weight: "120.5"}

      assert {:ok, %Pet{} = pet} = Announcements.create_pet(valid_attrs)
      assert pet.name == "some name"
      assert pet.size == Decimal.new("120.5")
      assert pet.bio == "some bio"
      assert pet.photos == ["option1", "option2"]
      assert pet.age == 42
      assert pet.gender == :male
      assert pet.breed == "some breed"
      assert pet.species == "some species"
      assert pet.spayed == true
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
      update_attrs = %{name: "some updated name", size: "456.7", bio: "some updated bio", photos: ["option1"], age: 43, gender: :female, breed: "some updated breed", species: "some updated species", spayed: false, dewormed: false, neutered: false, disability: false, pedigree: false, weight: "456.7"}

      assert {:ok, %Pet{} = pet} = Announcements.update_pet(pet, update_attrs)
      assert pet.name == "some updated name"
      assert pet.size == Decimal.new("456.7")
      assert pet.bio == "some updated bio"
      assert pet.photos == ["option1"]
      assert pet.age == 43
      assert pet.gender == :female
      assert pet.breed == "some updated breed"
      assert pet.species == "some updated species"
      assert pet.spayed == false
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
end
