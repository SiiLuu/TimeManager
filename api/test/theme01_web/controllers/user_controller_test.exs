defmodule Theme01Web.UserControllerTest do
  use Theme01Web.ConnCase

  import Theme01.UsersFixtures

  alias Theme01.Users.User

  @create_attrs %{
    id: 1,
    email: "manager01@test.com",
    username: "manager01",
    role: "Manager",
    password_hash: "password"
  }
  @update_attrs %{
    email: "test_updated@test.com",
    username: "test_updated"
  }
  @invalid_attrs %{email: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)
    end

    test "get user by email and username", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index), @create_attrs)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "get employees" do
    test "get_my_employees", %{
      conn: conn
    } do
      conn = get(conn, Routes.user_path(conn, :get_employees, 1))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "manager01@test.com",
               "username" => "manager01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "test_updated@test.com",
               "username" => "test_updated"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 403)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
