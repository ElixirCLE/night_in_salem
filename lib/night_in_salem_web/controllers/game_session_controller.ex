defmodule NightInSalemWeb.GameSessionController do
  use NightInSalemWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{ "game_session" => %{ "player_name" => player_name } }) do
    conn
      |> put_session(:player_name, player_name)
      |> redirect(to: game_session_path(conn, :show, 1))
  end

  def show(conn, %{ "id" => id }) do
    player_name = get_session(conn, :player_name)
    render conn, "show.html", player_name: player_name, user_token: Phoenix.Token.sign(conn, "player name", player_name)
  end

  def edit(conn, _params) do
    render conn, "edit.html"
  end

  def update(conn, %{ "game_session" => %{ "player_name" => player_name } }) do
    conn
      |> put_session(:player_name, player_name)
      |> redirect(to: game_session_path(conn, :show, 1))
  end
end
