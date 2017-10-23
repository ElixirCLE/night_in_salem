defmodule NightInSalem.GameMaster do
  use GenServer

  alias NightInSalem.Player

  @initial_state []

  ## Client Functions

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  defp process_for(game_id) do
    {:via, Registry, {GameMasterRegistry, game_id}}
  end

  def get_state(game_id) do
    GenServer.call(process_for(game_id), :get_state)
  end

  def set_state(game_id, new_state) do
    GenServer.cast(process_for(game_id), {:set_state, new_state})
  end

  def reset_game(game_id) do
    GenServer.cast(process_for(game_id), :reset_game)
  end

  def add_player(game_id, name) do
    GenServer.call(process_for(game_id), {:add_player, name})
  end

  def become_witch(game_id, name) do
    GenServer.cast(process_for(game_id), {:become_witch, name})
  end

  def become_constable(game_id, name) do
    GenServer.cast(process_for(game_id), {:become_constable, name})
  end

  def lose_constable(game_id, name) do
    GenServer.cast(process_for(game_id), {:lose_constable, name})
  end

  def become_dead(game_id, name) do
    GenServer.cast(process_for(game_id), {:become_dead, name})
  end

  ## Server Callback

  def init(:ok) do
    {:ok, @initial_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add_player, player_name}, _from, state) do
    if Enum.any?(state, fn user -> user.name == player_name end) do
      {:reply, {:error, :duplicate_name}, state}
    else
      {:reply, :ok, [%Player{name: player_name} | state]}
    end
  end

  def handle_cast({:set_state, new_state}, _state) do
    {:noreply, new_state}
  end

  def handle_cast(:reset_game, _state) do
    {:noreply, @initial_state}
  end

  def handle_cast({:become_witch, player_name}, state) do
    {:noreply, Player.become_witch(state, player_name)}
  end

  def handle_cast({:become_constable, player_name}, state) do
    {:noreply, Player.become_constable(state, player_name)}
  end

  def handle_cast({:lose_constable, player_name}, state) do
    {:noreply, Player.lose_constable(state, player_name)}
  end

  def handle_cast({:become_dead, player_name}, state) do
    {:noreply, Player.become_dead(state, player_name)}
  end

end
