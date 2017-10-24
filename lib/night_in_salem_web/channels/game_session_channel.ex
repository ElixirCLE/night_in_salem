defmodule NightInSalemWeb.GameSessionChannel do
  use NightInSalemWeb, :channel
  alias NightInSalemWeb.GameSessionPresence

  def join("game_session:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("game_session:" <> game_key, _params, socket) do
    socket =
      socket
      |> assign(:game_key, game_key)

    send self(), :after_join
    {:ok, %{data: %{}}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", GameSessionPresence.list(socket)
    {:ok, ref} = GameSessionPresence.track(socket, socket.assigns.player_name, %{ })
    {:noreply, socket}
  end

  defp authorized?(_) do
    true
  end
end
