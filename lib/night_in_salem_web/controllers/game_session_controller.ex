defmodule NightInSalemWeb.GameSessionController do
  use NightInSalemWeb, :controller
  alias NightInSalem.GameMasterSupervisor
  alias NightInSalem.GameMaster

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{ "game_session" => %{ "player_name" => player_name } }) do
    game_key = GameMasterSupervisor.start_game
    GameMaster.add_player(game_key, player_name)
    conn
      |> put_session(:player_name, player_name)
      |> put_session(:game_key, game_key)
      |> redirect(to: game_session_path(conn, :show, game_key))
  end

  def show(conn, %{ "id" => game_key }) do
    player_name = get_session(conn, :player_name)
    show_for_player(conn, game_key, player_name)
  end

  defp show_for_player(conn, game_key, nil) do
    conn
      |> redirect(to: game_session_path(conn, :edit, game_key))
  end

  defp show_for_player(conn, game_key, player_name) do
    render conn, "show.html", player_name: player_name, game_key: game_key, user_token: Phoenix.Token.sign(conn, "player name", player_name)
  end

  def edit(conn, %{ "id" => game_key }) do
    render conn, "edit.html", game_key: game_key
  end

  def update(conn, %{ "game_session" => %{ "player_name" => player_name }, "id" => game_key }) do
    GameMaster.add_player(game_key, player_name)
    conn
      |> put_session(:player_name, player_name)
      |> put_session(:game_key, game_key)
      |> redirect(to: game_session_path(conn, :show, game_key))
  end
end
