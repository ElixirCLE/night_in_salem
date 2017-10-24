defmodule NightInSalemWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "game_session:*", NightInSalemWeb.GameSessionChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "player name", token, max_age: 1209600) do
      {:ok, player_name} ->
        {:ok, assign(socket, :player_name, player_name)}
      {:error, _reason} ->
        :error
    end
  end

  def id(_socket), do: nil
end
