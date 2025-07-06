defmodule SimpleAppWeb.Router do
  use SimpleAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimpleAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleAppWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", SimpleAppWeb do
    pipe_through :api

    # Users API
    resources "/users", UserController, only: [:index, :show, :create, :update, :delete]
    post "/users/authenticate", UserController, :authenticate

    # Bikes API
    resources "/bikes", BikeController, only: [:index, :show, :create, :update, :delete]
    get "/bikes/search", BikeController, :search
    get "/users/:user_id/bikes", BikeController, :user_bikes

    # Trades API
    resources "/trades", TradeController, only: [:index, :show, :create, :update, :delete]
    get "/users/:user_id/trades", TradeController, :user_trades
    put "/trades/:id/accept", TradeController, :accept
    put "/trades/:id/reject", TradeController, :reject
    put "/trades/:id/cancel", TradeController, :cancel
  end
end