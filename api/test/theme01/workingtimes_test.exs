defmodule Theme01.WorkingtimesTest do
  use Theme01.DataCase

  alias Theme01.Workingtimes
  alias Theme01.Users

  describe "workingtimes" do
    alias Theme01.Workingtimes.Workingtime

    @invalid_attrs %{end: nil, start: nil, user_id: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = fixture(:workingtime)
      assert Workingtimes.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = fixture(:workingtime)
      assert Workingtimes.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      user = fixture_user(:user)

      valid_attrs = %{
        end: ~N[2021-10-25 08:00:00],
        start: ~N[2021-10-25 08:00:00],
        user_id: user.id
      }

      assert {:ok, %Workingtime{} = workingtime} = Workingtimes.create_workingtime(valid_attrs)
      assert workingtime.end == ~N[2021-10-25 08:00:00]
      assert workingtime.start == ~N[2021-10-25 08:00:00]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workingtimes.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = fixture(:workingtime)
      update_attrs = %{end: ~N[2021-10-26 10:00:00]}

      assert {:ok, %Workingtime{} = workingtime} =
               Workingtimes.update_workingtime(workingtime, update_attrs)

      assert workingtime.end == ~N[2021-10-26 10:00:00]
      assert workingtime.start == ~N[2021-10-25 08:00:00]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = fixture(:workingtime)

      assert {:error, %Ecto.Changeset{}} =
               Workingtimes.update_workingtime(workingtime, @invalid_attrs)

      assert workingtime == Workingtimes.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = fixture(:workingtime)
      assert {:ok, %Workingtime{} = workingtime} = Workingtimes.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Workingtimes.get_workingtime!(workingtime.id) end
    end

    def fixture_user(:user) do
      valid_user_attrs = %{
        username: "Some user",
        email: "someuse@mail.com",
        role: "Employee",
        password_hash: "password"
      }

      {:ok, user} = Users.create_user(valid_user_attrs)
      user
    end

    def fixture(:workingtime) do
      user = fixture_user(:user)
      workingtime_params = %{user_id: user.id, start: ~N[2021-10-25 08:00:00]}

      {:ok, workingtime} = Workingtimes.create_workingtime(workingtime_params)

      workingtime
    end
  end
end
