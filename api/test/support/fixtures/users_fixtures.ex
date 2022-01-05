defmodule Theme01.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Users` context.
  """
  use ExMachina.Ecto, repo: Theme01.Repo

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: sequence(:email, &"email#{&1}@test.com"),
        username: sequence(:email, &"username-#{&1}"),
        role: "Manager",
        manager_id: nil,
        team: nil,
        password_hash: "password"
      })
      |> Theme01.Users.create_user()

    user
  end
end
