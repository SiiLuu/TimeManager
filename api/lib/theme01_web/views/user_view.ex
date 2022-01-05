defmodule Theme01Web.UserView do
  use Theme01Web, :view
  alias Theme01Web.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      manager_id: user.manager_id,
      team: user.team
    }
  end

  def render("manager.json", %{user: user}) do
    %{
      manager: user.manager
    }
  end

  def render("jwt.json", %{jwt: jwt, user: user}) do
    %{
      jwt: jwt,
      user: %{
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
        manager_id: user.manager_id,
        team: user.team
      }
    }
  end
end
