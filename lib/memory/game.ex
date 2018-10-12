defmodule Memory.Game do
  def new do
    %{
      tiles: initalizeTiles(),
      current_tiles: [],
      matched: [],
      players: %{},
      next_player: "",
      winner: "",
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
      turn: -1, # 1 is there turn and -1 mean they are a watcher
    }
  end

  def client_view(game, user) do
    %{
      tiles: game.tiles,
      current_tiles: game.current_tiles,
      matched: game.matched,
      players: game.players,
      winner: game.winner,
    }
  end

  def initalizeTiles() do
    tiles = String.graphemes("AABBCCDDEEFFGGHH")
    Enum.shuffle(tiles)
  end

  def reset(game, player) do
    if observer(game, player) do
      game
    else
      new_p1 = Map.get(game.players, player)
      |> Map.put(:matches, 0)
      new_p2 = Map.get(game.players, game.next_player)
      |> Map.put(:matches, 0)
      players = game.players
      |> Map.put(player, new_p1)
      |> Map.put(game.next_player, new_p2)
      new()
      |> Map.put(:players, players)
      |> Map.put(:next_player, game.next_player)
    end
  end

  def add_player(game, player) do
    keys = Map.keys(game.players)
    if Enum.member?(keys, player) do
      game
    else
      cond do
        length(keys) == 0 ->
          pinfo = default_player()
          |> Map.put(:turn, 1)
          players = Map.put(game.players, player, pinfo)
          game
          |> Map.put(:players, players)
        length(keys) == 1 ->
          pinfo = default_player()
          |> Map.put(:turn, 0)
          players = Map.put(game.players, player, pinfo)
          game
          |> Map.put(:players, players)
          |> Map.put(:next_player, player)
        true ->
          pinfo = default_player()
          players = Map.put(game.players, player, pinfo)
          Map.put(game, :players, players)
      end
    end
  end

  def observer(game, player) do
    keys = Map.keys(game.players)
    turn = Map.get(game.players, player)
    |> Map.get(:turn)
    turn == -1
  end

  def not_playing(game, player) do
    keys = Map.keys(game.players)
    turn = Map.get(game.players, player)
    |> Map.get(:turn)
    turn == 0 || turn == -1 || length(keys) < 2
  end

  def flip_tile(game, player, tile_index) do
    if not_playing(game, player) do
      game
    else
      new_tiles = game.current_tiles ++ [tile_index]
      Map.put(game, :current_tiles, new_tiles)
    end
  end

  def compare_tiles(game, player, tile2) do
    :timer.sleep(1000)
    first_tile = Enum.at(game.tiles, Enum.at(game.current_tiles, 0))
    second_tile = Enum.at(game.tiles, tile2)
    if first_tile == second_tile do
      pinfo = Map.get(game.players, player)
      new_score = Map.get(pinfo, :matches) + 1
      new_pinfo = change_player(pinfo)
      |> Map.put(:matches, new_score)
      next_pinfo = Map.get(game.players, game.next_player)
      new_next_pinfo = change_player(next_pinfo)
      players = game.players
      |> Map.put(player, new_pinfo)
      |> Map.put(game.next_player, new_next_pinfo)
      matched = game.matched ++ game.current_tiles
      if length(matched) == 16 do
        winner = determine_winner(game, player, new_score)
        game
        |> Map.put(:winner, winner)
        |> Map.put(:matched, matched)
        |> Map.put(:players, players)
        |> Map.put(:current_tiles, [])
        |> Map.put(:next_player, player)
      else
        game
        |> Map.put(:matched, matched)
        |> Map.put(:players, players)
        |> Map.put(:current_tiles, [])
        |> Map.put(:next_player, player)
      end
    else
      pinfo = Map.get(game.players, player)
      new_pinfo = change_player(pinfo)
      next_pinfo = Map.get(game.players, game.next_player)
      new_next_pinfo = change_player(next_pinfo)
      players = game.players
      |> Map.put(player, new_pinfo)
      |> Map.put(game.next_player, new_next_pinfo)
      game
      |> Map.put(:current_tiles, [])
      |> Map.put(:players, players)
      |> Map.put(:next_player, player)
    end
  end

# determine winner
  def determine_winner(game, player, score1) do
    pinfo_player_other = Map.get(game.players, game.next_player)
    score2 = Map.get(pinfo_player_other, :matches)
    cond do
      score1 > score2 ->
        player
      score2 > score1 ->
        game.next_player
      true ->
        "draw"
    end
  end

  # return updated list of players
  def change_player(pinfo) do
    turn = Map.get(pinfo, :turn)
    cond do
      turn == 0 ->
        Map.put(pinfo, :turn, 1)
      turn == 1 ->
        Map.put(pinfo, :turn, 0)
      true ->
        Map.put(pinfo, :turn, -1)
    end
  end
end
