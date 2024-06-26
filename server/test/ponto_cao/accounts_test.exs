defmodule PontoCao.AccountsTest do
  use PontoCao.DataCase

  alias PontoCao.Accounts

  describe "users" do
    alias PontoCao.Accounts.User

    import PontoCao.AccountsFixtures

    @invalid_attrs %{
      name: nil,
      email: nil,
      bio: nil,
      avatar: nil,
      website: nil,
      social_links: nil,
      phone: nil,
      roles: nil
    }

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        name: "some name",
        email: "email@email.com",
        bio: "some bio",
        avatar: "some avatar",
        website: "https://google.com/",
        social_links: ["https://github.com/"],
        phone: "+5527992032080",
        roles: [:ADOPTER]
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.email == "email@email.com"
      assert user.bio == "some bio"
      assert user.avatar == "some avatar"
      assert user.website == "https://google.com/"
      assert user.social_links == ["https://github.com/"]
      assert user.phone == "+5527992032080"
      assert user.roles == [:ADOPTER]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        name: "some updated name",
        email: "someupdatedemail@email.com",
        bio: "some updated bio",
        avatar: "some updated avatar",
        website: "https://google.com/",
        social_links: ["https://linkedin.com/"]
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.email == "someupdatedemail@email.com"
      assert user.bio == "some updated bio"
      assert user.avatar == "some updated avatar"
      assert user.website == "https://google.com/"
      assert user.social_links == ["https://linkedin.com/"]
      assert user.roles == [:ADOPTER]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
