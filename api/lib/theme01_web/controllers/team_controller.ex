defmodule Theme01Web.TeamController do
  use Theme01Web, :controller

  alias Theme01.Teams
  alias Theme01.Teams.Team
  alias Theme01.Workingtimes

  action_fallback(Theme01Web.FallbackController)

  def index(conn, %{"managerID" => managerID}) do
    user_logged = Guardian.Plug.current_resource(conn)

    if user_logged.role == :GeneralManager do
      teams = Teams.list_teams()
      render(conn, "index.json", teams: teams)
    else
      teams = Teams.list_manager_teams(managerID)
      render(conn, "index.json", teams: teams)
    end
  end

  def index_for_gm(conn, _params) do
    teams = Teams.list_teams()
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params, "managerID" => managerID}) do
    with {:ok, %Team{} = team} <- Teams.create_team(Map.put(team_params, "manager_id", managerID)) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_workingtimes(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    workingtimes = Workingtimes.get_all_by_team(team.id)
    render(conn, "workingtimes.json", workingtimes: workingtimes)
  end
end
