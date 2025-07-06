defmodule SimpleAppWeb.PageController do
  use SimpleAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end