defmodule Theme01.TeamsTest do
  use Theme01.DataCase

  alias Theme01.Teams
  alias Theme01.Users

  describe "teams" do
    alias Theme01.Teams.Team

    @invalid_attrs %{name: nil, managerID: nil}

    test "list_teams/0 returns all teams" do
      team = fixture(:team)
      teams = Teams.list_teams()
    end

    test "get_team!/1 returns the team with given id" do
      team = fixture(:team)
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      user = fixture_user(:user)
      valid_attrs = %{name: "some name", manager_id: user.id}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = fixture(:team)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = fixture(:team)
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = fixture(:team)
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = fixture(:team)
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end

    def fixture_user(:user) do
      valid_user_attrs = %{
        username: "Some user",
        email: "someuse@mail.com",
        role: "GeneralManager",
        password_hash: "password"
      }

      {:ok, user} = Users.create_user(valid_user_attrs)
      user
    end

    def fixture(:team) do
      user = fixture_user(:user)
      team_params = %{manager_id: user.id, name: "Team A"}

      {:ok, team} = Teams.create_team(team_params)

      team
    end
  end
end
