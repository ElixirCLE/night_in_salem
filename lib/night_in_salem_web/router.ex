defmodule NightInSalemWeb.Router do
  use NightInSalemWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NightInSalemWeb do
    pipe_through :browser # Use the default browser stack

    resources "/player", GamePlayerController, only: [:new, :create]
    resources "/", GameSessionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", NightInSalemWeb do
  #   pipe_through :api
  # end
end
