defmodule Memory.Game do
  def new do
    %{
      tiles: initalizeTiles(),
      attempts: 0,
      current_tiles: [],
      matched: [],
      last_tile: NULL,
      }
  end

  def client_view(game) do
    %{
      attempts: game.attempts,
      tiles: game.tiles,
      current_tiles: game.current_tiles,
      matched: game.matched,
    }
  end

  def initalizeTiles() do
    tiles = String.graphemes("AABBCCDDEEFFGGHH")
    Enum.shuffle(tiles)
  end

  def flip_tile(game, tile_index) do
    new_tiles = game.current_tiles ++ [tile_index]
    Map.put(game, :current_tiles, new_tiles)
    |> Map.put(:attempts, game.attempts+1)
  end

  # Determine if the tile should be matched
  def determine_match(game, tile_index) do
    if game.last_tile != NULL do
      first = Enum.at(game.tiles, Enum.at(game.current_tiles, 0))
      second = Enum.at(game.tiles, Enum.at(game.current_tiles, 1))
      if first == second do
        matches = game.matched ++ game.current_tiles
        Map.put(game, :matched, matches)
        |> Map.put(:current_tiles, [])
      else
        Map.put(game, :current_tiles, [])
        |> Map.put(:last_tile, NULL)
      end
    else
      Map.put(game, :last_tile, tile_index)
    end
  end
end
