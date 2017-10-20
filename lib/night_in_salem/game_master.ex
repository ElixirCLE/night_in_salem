defmodule NightInSalem.GameMaster do
  use GenServer

  alias NightInSalem.Player

  @initial_state []

  ## Client Functions

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: GameMaster)
  end

  def get_state() do
    GenServer.call(GameMaster, :get_state)
  end

  def set_state(new_state) do
    GenServer.cast(GameMaster, {:set_state, new_state})
  end

  def reset_game do
    GenServer.cast(GameMaster, :reset_game)
  end

  def add_player(name) do
    GenServer.call(GameMaster, {:add_player, name})
  end

  def become_witch(name) do
    GenServer.cast(GameMaster, {:become_witch, name})
  end

  def become_constable(name) do
    GenServer.cast(GameMaster, {:become_constable, name})
  end

  def lose_constable(name) do
    GenServer.cast(GameMaster, {:lose_constable, name})
  end

  def become_dead(name) do
    GenServer.cast(GameMaster, {:become_dead, name})
  end

  ## Server Callback

  def init(:ok) do
    {:ok, @initial_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add_player, player_name}, _from, state) do
    if Enum.any?(state, fn user -> user[:name] == player_name end) do
      {:reply, {:error, :duplicate_name}, state}
    else
      {:reply, :ok, [new_player(player_name) | state]}
    end
  end

  def handle_cast({:set_state, new_state}, _state) do
    {:noreply, new_state}
  end

  def handle_cast(:reset_game, _state) do
    {:noreply, @initial_state}
  end

  def handle_cast({:become_witch, player_name}, state) do
    {:noreply, become_witch(state, player_name)}
  end

  def handle_cast({:become_constable, player_name}, state) do
    {:noreply, become_constable(state, player_name)}
  end

  def handle_cast({:lose_constable, player_name}, state) do
    {:noreply, lose_constable(state, player_name)}
  end

  def handle_cast({:become_dead, player_name}, state) do
    {:noreply, become_dead(state, player_name)}
  end

  defp become_witch([], _player_name), do: []
  defp become_witch([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :witch, true) | rest ]
  end
  defp become_witch([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | become_witch(rest_of_users, player_name)]
  end

  defp become_constable([], _player_name), do: []
  defp become_constable([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :constable, true) | rest ]
  end
  defp become_constable([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | become_constable(rest_of_users, player_name)]
  end

  defp lose_constable([], _player_name), do: []
  defp lose_constable([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :constable, false) | rest ]
  end
  defp lose_constable([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | lose_constable(rest_of_users, player_name)]
  end

  defp become_dead([], _player_name), do: []
  defp become_dead([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :dead, true) | rest ]
  end
  defp become_dead([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | become_dead(rest_of_users, player_name)]
  end

  defp new_player(name) do
    %Player{name: name}
  end
end
