defmodule Theme01.Workingtimes.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field(:end, :naive_datetime)
    field(:start, :naive_datetime)
    belongs_to(:user, Users.User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :user_id])
  end
end
