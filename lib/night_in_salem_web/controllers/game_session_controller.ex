defmodule NightInSalemWeb.GameSessionController do
  use NightInSalemWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{ "game_session" => %{ "player_name" => player_name } }) do
    conn = put_session(conn, :player_name, player_name)
    redirect(conn, to: game_session_path(conn, :show, 1))
  end

  def show(conn, %{ "id" => id }) do
    render conn, "show.html", player_name: get_session(conn, :player_name)
  end

  def edit(conn, _params) do
    render conn, "edit.html"
  end

  def update(conn, %{ "game_session" => %{ "player_name" => player_name } }) do
    conn = put_session(conn, :player_name, player_name)
    redirect(conn, to: game_session_path(conn, :show, 1))
  end
end
