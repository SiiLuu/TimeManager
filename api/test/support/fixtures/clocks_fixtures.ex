defmodule Theme01.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2021-10-25 07:56:00]
      })
      |> Theme01.Clocks.create_clock()

    clock
  end
end
