defmodule Theme01.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string, null: false)
      add(:email, :string, null: false)

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
