defmodule PontoCao.UsersTest do
  use PontoCao.DataCase
  alias PontoCao.Users
  import PontoCao.UsersFixtures

  describe "complete_profile/2" do
    @valid_attrs %{
      name: "John Doe",
      bio: "I'm a developer",
      phone: "11999999999"
    }

    @invalid_attrs %{
      name: nil,
      country: nil,
      bio: nil,
      phone: nil,
      social_links: nil,
      avatar: nil,
      website: nil
    }

    test "with valid data" do
      user = user_fixture()
      assert {:ok, user} = Users.complete_profile(user, @valid_attrs)
      assert user.name == "John Doe"
      assert user.country == "BR"
      assert user.bio == "I'm a developer"
      assert user.phone == "+5511999999999"
    end

    test "with invalid data" do
      user = user_fixture()
      assert {:error, changeset} = Users.complete_profile(user, @invalid_attrs)
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:country] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:bio] == {"can't be blank", [validation: :required]}
      assert changeset.valid? == false
    end
  end

  describe "set_roles/2" do
    @valid_attrs %{
      roles: ["ADOPTER"]
    }

    @invalid_attrs %{
      roles: ["INVALID_ROLE"]
    }

    test "with valid roles" do
      user = user_fixture()
      assert {:ok, user} = Users.set_roles(user, @valid_attrs)
      assert user.roles == [:ADOPTER]
    end

    test "with invalid roles" do
      user = user_fixture()
      assert {:error, changeset} = Users.set_roles(user, @invalid_attrs)
      assert changeset.valid? == false
    end
  end

  describe "get!/1" do
    test "when the user exists" do
      user = user_fixture()
      assert Users.get!(user.id) == user
    end

    test "when the user does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Users.get!(0)
      end
    end
  end
end
