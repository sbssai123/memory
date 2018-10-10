defmodule Memory.Game do
  def new do
    %{
      tiles: initalizeTiles(),
      current_tiles: [],
      matched: [],
      players: %{},
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
      matches: 0, # of tiles matched
      turn: 0, # ability to control the board
    }
  end


  def client_view(game, user) do
    ps = Enum.map game.players, fn {pn, pi} ->
      %{ name: pn, matches: Enum.into(pi.matches, 0) }
    end
    %{
      tiles: game.tiles,
      current_tiles: game.current_tiles,
      matched: game.matched,
      players: ps,
    }
  end

  def initalizeTiles() do
    tiles = String.graphemes("AABBCCDDEEFFGGHH")
    Enum.shuffle(tiles)
  end

  def flip_tile(game, player, tile_index) do
      new_tiles = game.current_tiles ++ [tile_index]
      Map.put(game, :current_tiles, new_tiles)
        # first = Enum.at(game.current_tiles, 0)
        # # compare the tiles at the two indices
        # # :timer.sleep(1000)
        # compare_tiles(game, player, first, tile_index)
      # true ->
      #   new_tiles = game.current_tiles ++ [tile_index]
      #   Map.put(game, :current_tiles, new_tiles)
    # end
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

  # Determine if the tile should be matched
#   def determine_match(game, tile_index) do
#     if game.last_tile != NULL do
#       first = Enum.at(game.tiles, Enum.at(game.current_tiles, 0))
#       second = Enum.at(game.tiles, Enum.at(game.current_tiles, 1))
#       if first == second do
#         matches = game.matched ++ game.current_tiles
#         Map.put(game, :matched, matches)
#         |> Map.put(:current_tiles, [])
#       else
#         Map.put(game, :current_tiles, [])
#         |> Map.put(:last_tile, NULL)
#       end
#     else
#       Map.put(game, :last_tile, tile_index)
#     end
#   end
