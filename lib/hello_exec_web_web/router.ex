defmodule HelloExecWebWeb.Router do
  use HelloExecWebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HelloExecWebWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloExecWebWeb do
    pipe_through :browser

    live "/", HomeLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloExecWebWeb do
  #   pipe_through :api
  # end
end
