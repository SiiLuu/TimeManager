defmodule Theme01.Workingtimes do
  @moduledoc """
  The Workingtimes context.
  """

  import Ecto.Query, warn: false
  alias Theme01.Repo

  alias Theme01.Workingtimes.Workingtime
  alias Theme01.Users.User

  @doc """
  Returns the list of workingtimes.
  
  ## Examples
  
      iex> list_workingtimes()
      [%Workingtime{}, ...]
  
  """
  def list_workingtimes do
    Repo.all(Workingtime)
  end

  def user_workingtime(user) do
    query =
      from(w in Workingtime,
        where: w.user_id == ^user
      )

    Repo.all(query)
  end

  @doc """
  Gets a single workingtime.
  
  Raises `Ecto.NoResultsError` if the Workingtime does not exist.
  
  ## Examples
  
      iex> get_workingtime!(123)
      %Workingtime{}
  
      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  @doc """
  Creates a workingtime.
  
  ## Examples
  
      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}
  
      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.
  
  ## Examples
  
      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}
  
      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtime.
  
  ## Examples
  
      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}
  
      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.
  
  ## Examples
  
      iex> change_workingtime(workingtime)
      %Ecto.Changeset{data: %Workingtime{}}
  
  """
  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

  def get_all_by_team(team_id) do
    Repo.all(
      from(w in Workingtime,
        join: u in User,
        on: u.id == w.user_id,
        where: w.user_id == u.id,
        where: u.team == ^team_id,
        preload: [user: u]
      )
    )
  end
end
