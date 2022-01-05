defmodule Theme01.Repo.Migrations.AddRoleToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      remove(:manager)
      add(:role, :string)
      add(:manager_id, references(:users, on_delete: :nothing), null: true)
    end
  end
end
