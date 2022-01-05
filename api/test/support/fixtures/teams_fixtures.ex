defmodule Theme01.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Theme01.Teams.create_team()

    team
  end
end
