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
    game_id = GameMasterSupervisor.start_game
    GameMaster.add_player(game_id, player_name)
    conn
      |> put_session(:player_name, player_name)
      |> redirect(to: game_session_path(conn, :show, game_id))
  end

  def show(conn, %{ "id" => game_id }) do
    player_name = get_session(conn, :player_name)
    show_for_player(conn, game_id, player_name)
  end

  defp show_for_player(conn, game_id, nil) do
    conn
      |> redirect(to: game_session_path(conn, :edit, game_id))
  end

  defp show_for_player(conn, game_id, player_name) do
    render conn, "show.html", player_name: player_name, game_id: game_id, user_token: Phoenix.Token.sign(conn, "player name", player_name)
  end

  def edit(conn, %{ "id" => game_id }) do
    render conn, "edit.html", game_id: game_id
  end

  def update(conn, %{ "game_session" => %{ "player_name" => player_name }, "id" => game_id }) do
    GameMaster.add_player(game_id, player_name)
    conn
      |> put_session(:player_name, player_name)
      |> put_session(:game_id, game_id)
      |> redirect(to: game_session_path(conn, :show, game_id))
  end
end
