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

  ## Implementations
  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    {:reply, Game.client_view(gg, user), Map.put(game, gg)}
  end

  def handle_call({:click, game, user, tile}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.flip_tile(user, tile)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(game, gg)}
  end

end
