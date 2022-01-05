defmodule Theme01.Repo.Migrations.AddManagerBooleanToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :manager, :boolean, default: false
    end
  end
end
