defmodule PontoCao.ProfileTest do
  use PontoCao.DataCase

  alias PontoCao.Profile

  describe "addresses" do
    alias PontoCao.Profile.Address

    import PontoCao.ProfileFixtures

    @invalid_attrs %{state: nil, number: nil, street: nil, neighborhood: nil, zip_code: nil, latitude: nil, longitude: nil, city: nil}

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Profile.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Profile.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      valid_attrs = %{state: "some state", number: 42, street: "some street", neighborhood: "some neighborhood", zip_code: "some zip_code", latitude: "120.5", longitude: "120.5", city: "some city"}

      assert {:ok, %Address{} = address} = Profile.create_address(valid_attrs)
      assert address.state == "some state"
      assert address.number == 42
      assert address.street == "some street"
      assert address.neighborhood == "some neighborhood"
      assert address.zip_code == "some zip_code"
      assert address.latitude == Decimal.new("120.5")
      assert address.longitude == Decimal.new("120.5")
      assert address.city == "some city"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profile.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      update_attrs = %{state: "some updated state", number: 43, street: "some updated street", neighborhood: "some updated neighborhood", zip_code: "some updated zip_code", latitude: "456.7", longitude: "456.7", city: "some updated city"}

      assert {:ok, %Address{} = address} = Profile.update_address(address, update_attrs)
      assert address.state == "some updated state"
      assert address.number == 43
      assert address.street == "some updated street"
      assert address.neighborhood == "some updated neighborhood"
      assert address.zip_code == "some updated zip_code"
      assert address.latitude == Decimal.new("456.7")
      assert address.longitude == Decimal.new("456.7")
      assert address.city == "some updated city"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Profile.update_address(address, @invalid_attrs)
      assert address == Profile.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Profile.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Profile.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Profile.change_address(address)
    end
  end
end
