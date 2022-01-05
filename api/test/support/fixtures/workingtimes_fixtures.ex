defmodule Theme01.WorkingtimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Workingtimes` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: nil,
        start: ~N[2021-10-25 08:00:00]
      })
      |> Theme01.Workingtimes.create_workingtime()

    workingtime
  end
end
