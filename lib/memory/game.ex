defmodule Memory.Game do
  def new do
    %{
      tiles: initalizeTiles(),
      current_tiles: [],
      matched: [],
      players: [],
      }
  end

  def new(players) do
    players = Enum.map players, fn {name, info} ->
      {name, %{ default_player() | matches: info.matches || 0 }}
    end
    Map.put(new(), :players, Enum.into(players, %{}))
  end


  def default_player() do
    %{
      name: "",
      matches: 0, # of tiles matched
      turn: -1, # it's there turn
    }
  end


  def client_view(game, user) do
    %{
      tiles: game.tiles,
      current_tiles: game.current_tiles,
      matched: game.matched,
      players: game.players,
    }
  end

  def initalizeTiles() do
    tiles = String.graphemes("AABBCCDDEEFFGGHH")
    Enum.shuffle(tiles)
  end

  def add_player(game, player) do
    # if length(game.players) < 2 do
    new_player = default_player()
    |> Map.put(:name, player)
    players = game.players ++ [new_player]
    Map.put(game, :players, players)
    # else
    #
    #   Map.put(game, :players, players)
    # end
  end


  def flip_tile(game, player, tile_index) do
      new_tiles = game.current_tiles ++ [tile_index]
      Map.put(game, :current_tiles, new_tiles)
  end

  def compare_tiles(game, player, tile2) do
    :timer.sleep(1000)
    first_tile = Enum.at(game.tiles, Enum.at(game.current_tiles, 0))
    second_tile = Enum.at(game.tiles, tile2)
    if first_tile == second_tile do
      matched = game.matched ++ game.current_tiles
      # player_score = player.matches + 1
      # pinfo = Map.get(game, player, default_player())
      # Map.put(player, :matches, player_score)
      # player_score = player.matches + 1
      # pinfo = Map.get(game, player, default_player())
      # |> Map.put(:matches, player_score)

      game
      |> Map.put(:matched, matched)
      # |> Map.update(:players, %{}, &(Map.put(&1, player, pinfo)))
      |> Map.put(:current_tiles, [])
    else
      Map.put(game, :current_tiles, [])
    end
  end
end
