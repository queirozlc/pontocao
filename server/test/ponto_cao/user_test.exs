defmodule PontoCao.UserTest do
  alias PontoCao.Users.User
  use PontoCao.DataCase

  test "changeset/2 set's default role as adopter" do
    user =
      %User{}
      |> User.changeset(%{})
      |> Ecto.Changeset.apply_changes()

    assert user.role == :adopter
  end

  describe "changeset_role/2" do
    test "with valid role" do
      changeset = User.role_changeset(%User{}, %{role: :donor})
      assert changeset.valid?
      refute changeset.errors[:role]
    end

    test "with invalid role" do
      changeset = User.role_changeset(%User{}, %{role: :invalid})
      refute changeset.valid?
      assert changeset.errors[:role]
    end
  end
end
