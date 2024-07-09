defmodule PontoCao.UsersTest do
  use PontoCao.DataCase
  alias PontoCao.{Users, Users.User}
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

  describe "update_user/2" do
    setup :create_user

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

    test "with valid data", %{user: user} do
      assert {:ok, user} = Users.update_user(user, @valid_attrs)
      assert user.name == "John Doe"
      assert user.bio == "I'm a developer"
      assert user.phone == "+5511999999999"
    end

    test "with invalid data", %{user: user} do
      assert {:error, changeset} = Users.update_user(user, @invalid_attrs)
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end
  end

  describe "delete_user/2" do
    setup :create_user

    test "with valid data", %{user: user} do
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get!(user.id) end
    end
  end

  defp create_user(_context) do
    user = user_fixture()
    {:ok, user: user}
  end
end
