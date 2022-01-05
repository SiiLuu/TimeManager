defmodule Theme01Web.Router do
  use Theme01Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {Theme01Web.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :jwt_authenticated do
    plug(Theme01.Guardian.AuthPipeline)
  end

  scope "/", Theme01Web do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", Theme01Web do
    pipe_through(:api)
    post("/users/sign_in", UserController, :sign_in)
    get("/users", UserController, :index)
  end

  scope "/api", Theme01Web do
    pipe_through([:api, :jwt_authenticated])
    resources("/users", UserController, except: [:index, :new, :edit])
    resources("/:managerID/teams", TeamController, except: [:new, :edit, :update, :delete])

    resources("/workingtimes", WorkingtimeController,
      except: [:new, :edit, :update, :delete, :show, :index]
    )

    post("/user/promote/:id", UserController, :promote)
    post("/users/:managerID/employees", UserController, :create_employee)
    get("/users/:managerID/employees", UserController, :get_employees)
    post("/workingtimes/:userID", WorkingtimeController, :create)
    get("/workingtimes/:userID", WorkingtimeController, :index)
    get("/workingtime/:userID/:id", WorkingtimeController, :show)
    put("/workingtime/:userID/:id", WorkingtimeController, :update)
    delete("/workingtime/:userID/:id", WorkingtimeController, :delete)
    get("/teams/:id/workingtimes", TeamController, :get_workingtimes)
    get("/teams", TeamController, :index_for_gm)
    put("/team/:id", TeamController, :update)
    delete("/team/:id", TeamController, :delete)
  end
end
