defmodule NightInSalemWeb.PageController do
  use NightInSalemWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
