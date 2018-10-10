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
      {name, %{ matches: info.matches || 0 }}
    end
    Map.put(new(), :players, Enum.into(players, %{}))
  end


  def default_player() do
    %{
      matches: 0, # of tiles matched
    }
  end


  def client_view(game) do
    ps = Enum.map game.players, fn {pn, pi} ->
      %{ name: pn, matches: pi.matches }
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

  # def get_cd(game, user) do
  #   done = (get_in(game.players, [user, :cooldown]) || 0)
  #   left = done - :os.system_time(:milli_seconds)
  #   max(left, 0)
  # end

  # def flip_tile(game, player, tile_index) do
  #   new_tiles = game.current_tiles ++ [tile_index]
  #   Map.put(game, :current_tiles, new_tiles)
  #   |> Map.put(:attempts, game.attempts+1)
  # end

  def flip_tiles(game, player, tile_index) do
    new_tiles = game.current_tiles ++ [tile_index]
    Map.put(game, :current_tiles, new_tiles)
    |> Map.put(:attempts, game.attempts+1)
    if length(current_tiles) == 2 do
      new_tiles = game.current_tiles ++ [tile_index]
      first = Enum.at(game.current_tiles, 0)
      # compare the tiles at the two indices
      :timer.sleep(1000)
      compare_tiles(game, player, first, tile_index)
    end
  end

  def compare_tiles(game, player, tile1, tile2) do
    first_tile = Enum.at(game.tiles, tile1)
    second_tile = Enum.at(game.tiles, tile2)
    if first_tile == second_tile do
      matched = game.matched ++ game.current_tiles

      player_score = player.matches + 1;
      pinfo = Map.get(game, player, default_player())
      |> Map.update(:matches, player_score)

      game
      |> Map.put(:matched, matched)
      |> Map.update(:players, %{}, &(Map.put(&1, player, pinfo)))
      |> Map.update(:current_tiles, []))
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
# end
