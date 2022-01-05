defmodule Theme01Web.TeamView do
  use Theme01Web, :view
  alias Theme01Web.TeamView
  alias Theme01Web.WorkingtimeView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "t.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      manager: team.user.username,
      manager_id: team.user.id
    }
  end

  def render("t.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      manager: team.manager_id
    }
  end

  def render("workingtimes.json", %{workingtimes: workingtimes}) do
    %{data: render_many(workingtimes, WorkingtimeView, "wt.json")}
  end
end
