defmodule Theme01Web.WorkingtimeControllerTest do
  use Theme01Web.ConnCase

  alias Theme01.Users
  alias Theme01.Workingtimes.Workingtime
  alias Theme01.Workingtimes

  @create_attrs %{
    start: ~N[2021-10-25 08:00:00]
  }
  @update_attrs %{
    end: ~N[2021-10-26 08:00:00]
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    test "lists all workingtimes", %{conn: conn} do
      {:ok, user} =
        Users.create_user(%{
          email: "test@test.com",
          username: "test",
          role: "Employee",
          password_hash: "password"
        })

      conn = get(conn, Routes.workingtime_path(conn, :index, user.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn} do
      {:ok, user} =
        Users.create_user(%{
          email: "test@test.com",
          username: "test",
          role: "Employee",
          password_hash: "password"
        })

      conn =
        post(conn, Routes.workingtime_path(conn, :create, user.id), workingtime: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.workingtime_path(conn, :show, user.id, id))

      assert %{
               "id" => ^id,
               "start" => "2021-10-25T08:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, user} =
        Users.create_user(%{
          email: "test@test.com",
          username: "test",
          role: "Employee",
          password_hash: "password"
        })

      conn =
        post(conn, Routes.workingtime_path(conn, :create, user.id), workingtime: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workingtime" do
    setup [:create_workingtime]

    test "renders workingtime when data is valid", %{
      conn: conn,
      workingtime: %Workingtime{id: id} = workingtime
    } do
      {:ok, user} =
        Users.create_user(%{
          email: "test@test.com",
          username: "test",
          role: "Employee",
          password_hash: "password"
        })

      conn =
        put(conn, Routes.workingtime_path(conn, :update, workingtime.user_id, workingtime),
          workingtime: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.workingtime_path(conn, :show, workingtime.user_id, id))

      assert %{
               "id" => ^id,
               "end" => "2021-10-26T08:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workingtime: workingtime} do
      conn =
        put(conn, Routes.workingtime_path(conn, :update, workingtime.user_id, workingtime),
          workingtime: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workingtime" do
    setup [:create_workingtime]

    test "deletes chosen workingtime", %{conn: conn, workingtime: workingtime} do
      conn =
        delete(conn, Routes.workingtime_path(conn, :delete, workingtime.user_id, workingtime))

      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.workingtime_path(conn, :show, workingtime.user_id, workingtime))
      end)
    end
  end

  defp create_workingtime(_) do
    workingtime = fixture(:workingtime)
    %{workingtime: workingtime}
  end

  def fixture_user(:user) do
    valid_user_attrs = %{
      username: "Some user",
      email: "someuse@mail.com",
      role: "Employee",
      password_hash: "password"
    }

    {:ok, user} = Users.create_user(valid_user_attrs)
    user
  end

  def fixture(:workingtime) do
    user = fixture_user(:user)
    workingtime_params = %{user_id: user.id, start: ~N[2021-10-25 08:00:00]}

    {:ok, workingtime} = Workingtimes.create_workingtime(workingtime_params)

    workingtime
  end
end
