defmodule NightInSalem.Player do
  defstruct name: "", 
            witch: false,
            constable: false,
            dead: false

  def become_witch([], _player_name), do: []
  def become_witch([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :witch, true) | rest ]
  end
  def become_witch([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | become_witch(rest_of_users, player_name)]
  end

  def become_constable([], _player_name), do: []
  def become_constable([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :constable, true) | rest ]
  end
  def become_constable([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | become_constable(rest_of_users, player_name)]
  end

  def lose_constable([], _player_name), do: []
  def lose_constable([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :constable, false) | rest ]
  end
  def lose_constable([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | lose_constable(rest_of_users, player_name)]
  end

  def become_dead([], _player_name), do: []
  def become_dead([%{name: player_name} = user | rest], player_name) do
    [ Map.put(user, :dead, true) | rest ]
  end
  def become_dead([non_matching_user | rest_of_users], player_name) do
    [non_matching_user | become_dead(rest_of_users, player_name)]
  end
end
