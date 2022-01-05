defmodule Theme01.UsersTest do
  use Theme01.DataCase

  alias Theme01.Users

  describe "users" do
    alias Theme01.Users.User

    import Theme01.UsersFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "test@test.com",
        username: "test",
        role: "Employee",
        password_hash: "password"
      }

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.email == "test@test.com"
      assert user.username == "test"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "test_updated@test.com", username: "test_updated"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.email == "test_updated@test.com"
      assert user.username == "test_updated"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
