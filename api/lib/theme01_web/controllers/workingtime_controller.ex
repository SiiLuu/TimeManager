defmodule Theme01Web.WorkingtimeController do
  use Theme01Web, :controller

  alias Theme01.Workingtimes
  alias Theme01.Workingtimes.Workingtime
  alias Theme01.Users

  action_fallback(Theme01Web.FallbackController)

  def index(conn, %{"userID" => userID}) do
    if Users.get_user!(userID) do
      workingtimes = Workingtimes.user_workingtime(userID)
      render(conn, "index.json", workingtimes: workingtimes)
    end
  end

  def create(conn, %{"workingtime" => workingtime_params, "userID" => userID}) do
    if Users.get_user!(userID) do
      with {:ok, %Workingtime{} = workingtime} <-
             Workingtimes.create_workingtime(Map.put(workingtime_params, "user_id", userID)) do
        conn
        |> put_status(:created)
        |> render("show.json", workingtime: workingtime)
      end
    end
  end

  def show(conn, %{"userID" => userID, "id" => id}) do
    if(Users.get_user!(userID)) do
      workingtime = Workingtimes.get_workingtime!(id)
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def update(conn, %{"userID" => userID, "id" => id, "workingtime" => workingtime_params}) do
    if(Users.get_user!(userID)) do
      workingtime = Workingtimes.get_workingtime!(id)

      with {:ok, %Workingtime{} = workingtime} <-
             Workingtimes.update_workingtime(workingtime, workingtime_params) do
        render(conn, "show.json", workingtime: workingtime)
      end
    end
  end

  def delete(conn, %{"userID" => userID, "id" => id}) do
    if(Users.get_user!(userID)) do
      workingtime = Workingtimes.get_workingtime!(id)

      with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
