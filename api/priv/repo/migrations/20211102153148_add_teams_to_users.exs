defmodule Theme01.Repo.Migrations.AddTeamsToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:team, references(:teams, on_delete: :nothing), null: true)
    end
  end
end
