defmodule NightInSalem.GameMasterSupervisor do
  use Supervisor

  alias NightInSalem.GameMaster

  @game_token_length 4
  @name GameMasterSupervisor

  def start_game do
    game_id = generate_game_token()
    game_name = via_tuple(game_id)
    Supervisor.start_child(@name, [[name: game_name]])
    game_id
  end

  defp via_tuple(game_id) do
    {:via, Registry, {GameMasterRegistry, game_id}}
  end

  def start_link(opts \\ []) do
    Supervisor.start_link([game_master_spec()], [strategy: :simple_one_for_one, name: @name] ++ opts)
  end

  def game_master_spec do
    Supervisor.child_spec(GameMaster, start: {GameMaster, :start_link, []})
  end

  def init(:ok) do
    Supervisor.init([], strategy: :simple_one_for_one)
  end

  defp generate_game_token do
    @game_token_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, @game_token_length)
    |> String.upcase
  end
end
