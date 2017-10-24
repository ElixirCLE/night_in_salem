defmodule NightInSalemWeb.GameMasterSupervisorTest do
  use ExUnit.Case, async: true

  alias NightInSalem.GameMasterSupervisor, as: GMS
  alias NightInSalem.GameMaster, as: GM

  setup do
    Supervisor.stop(GameMasterSupervisor)
    Process.sleep(1) # Yep. This is enough time for the supervisor to restart.
    # Replace this once a better way to ensure all children are deleted is found
  end

  describe "start_game/0" do
    test "returns a game identifier" do
      game_id = GMS.start_game
      assert game_id |> is_binary
      assert game_id |> String.length == 4
    end

    test "starts a child process" do
      GMS.start_game
      #IO.inspect Supervisor.which_children(GameMasterSupervisor)
      assert Supervisor.count_children(GameMasterSupervisor)[:active] == 1
    end

    test "starts a game master accessible by its game_id" do
      game_id = GMS.start_game
      assert GM.get_state(game_id) == []
    end
  end
end
