defmodule NightInSalemWeb.GamePlayerController do
  use NightInSalemWeb, :controller
  alias NightInSalem.GameMasterSupervisor
  alias NightInSalem.GameMaster

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{ "game_session" => %{ "player_name" => player_name, "game_key" => game_key } }) do
    GameMaster.add_player(game_key, player_name)
    conn
      |> put_session(:player_name, player_name)
      |> put_session(:game_key, game_key)
      |> redirect(to: game_session_path(conn, :show, game_key))
  end


end
