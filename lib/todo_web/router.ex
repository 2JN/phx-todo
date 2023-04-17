defmodule TodoWeb.Router do
  use TodoWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {TodoWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TodoWeb do
    pipe_through(:browser)

    get("/", ItemController, :index)
    get("/items/clear", ItemController, :clear_completed)
    get("/items/toggle/:id", ItemController, :toggle)
    get("/items/filter/:filter", ItemController, :index)
    resources("/items", ItemController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoWeb do
  #   pipe_through :api
  # end
end
