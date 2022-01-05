defmodule Theme01Web.ClockController do
  use Theme01Web, :controller

  alias Theme01.Clocks
  alias Theme01.Clocks.Clock
  alias Theme01.Users

  action_fallback Theme01Web.FallbackController

  def index(conn, %{"userID" => userID}) do
    clocks = Clocks.user_clocks(userID)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params, "userID" => userID}) do
    %{"time" => timeValue, "status" => statusValue} = clock_params
    newValue = %{time: timeValue, status: statusValue, user: userID}

    with {:ok, %Clock{} = clock} <-
           Users.get_user!(userID) && Clocks.create_clock(newValue) do
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end
end
