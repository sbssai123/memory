defmodule Memory.GameServer do
  use GenServer

  alias Memory.Game

  ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
    GenServer.call(__MODULE__, {:view, game, user})
  end

  def click(game, user, tile) do
    GenServer.call(__MODULE__, {:click, game, user, tile})
  end

  def match(game, user, tile) do
    GenServer.call(__MODULE__, {:match, game, user, tile})
  end

  def add_user(game, user) do
    GenServer.call(__MODULE__, {:new_player, game, user})
  end

  ## Implementations
  def init(state) do
    {:ok, state}
  end

  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:click, game, user, tile}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.flip_tile(user, tile)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:match, game, user, tile}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.compare_tiles(user, tile)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:new_player, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.add_player(user)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

end
