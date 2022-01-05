defmodule Theme01.Repo.Migrations.AddPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:password_hash, :string, null: false)
    end
  end
end
