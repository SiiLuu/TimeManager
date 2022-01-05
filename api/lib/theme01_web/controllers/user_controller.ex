defmodule Theme01Web.UserController do
  use Theme01Web, :controller

  alias Theme01.Users
  alias Theme01.Users.User

  action_fallback(Theme01Web.FallbackController)

  def index(conn, params) do
    if Map.has_key?(params, "username") && Map.has_key?(params, "email") do
      %{"email" => emailValue, "username" => usernameValue} = params
      users = Users.find_by_email_and_username(emailValue, usernameValue)
      render(conn, "index.json", users: users)
    else
      users = Users.list_users()
      render(conn, "index.json", users: users)
    end
  end

  def sign_in(conn, %{"user" => user_params}) do
    if Map.has_key?(user_params, "email") && Map.has_key?(user_params, "password") do
      try do
        user = Users.get_user_by_email(Map.get(user_params, "email"))

        if user do
          case Bcrypt.check_pass(user, Map.get(user_params, "password")) do
            {:ok, user} ->
              case Users.token_sign_in(user) do
                {:ok, token, _claims} ->
                  conn |> render("jwt.json", jwt: token, user: user)

                _ ->
                  {:error, :unauthorized}
              end

            {:error, _} ->
              {:error, :unauthorized}
          end
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Login error"})
        end
      rescue
        Ecto.NoResultsError ->
          {:error, :not_found, "Bad credentials"}
      end
    else
      {:error, :unauthorized}
    end
  end

  def get_employees(conn, %{"managerID" => managerID}) do
    user_logged = Guardian.Plug.current_resource(conn)

    if user_logged.role == :GeneralManager do
      users = Users.list_users()
      render(conn, "index.json", users: users)
    else
      users = Users.get_my_employees(managerID)
      render(conn, "index.json", users: users)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def create_employee(conn, %{"managerID" => managerID, "user" => user_params}) do
    user_logged = Guardian.Plug.current_resource(conn)

    if user_logged.role == :GeneralManager || user_logged.role == :Manager do
      with {:ok, %User{} = user} <-
             Users.create_user(Map.put(user_params, "manager_id", managerID)) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    user_logged = Guardian.Plug.current_resource(conn)
    role_security = true

    if Map.has_key?(user_params, "role") do
      %{"role" => role} = user_params
      role_security = user.role == role
    end

    if user_logged.role == :GeneralManager || role_security do
      with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end

  def promote(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    user_logged = Guardian.Plug.current_resource(conn)

    if user_logged.role == :GeneralManager do
      with {:ok, %User{} = user} <- Users.promote_user(user) do
        send_resp(conn, :ok, "")
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    user_logged = Guardian.Plug.current_resource(conn)

    if user.role == :GeneralManager do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Cannot delete General Manager user"})
    else
      if user_logged.role == :GeneralManager || user_logged == user do
        Users.delete_user(user)

        conn
        |> send_resp(200, "User deleted")
        |> halt()
      else
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Cannot delete user"})
      end
    end
  end
end
