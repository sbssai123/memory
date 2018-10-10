# This file was based heavily on the game_channel.ex game in the hangman
# we did in class.
defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.GameServer

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"tile_index" => i}, socket) do
    view = GameServer.click(socket.assigns[:game], socket.assigns[:user], ll)
    {:reply, {:ok, %{ "game" => view}}, socket}
  end

  # def handle_in("match", %{"tile_index" => i}, socket) do
  #   name = socket.assigns[:name]
  #   game = Game.determine_match(socket.assigns[:game], i)
  #   socket = assign(socket, :game, game)
  #   BackupAgent.put(name, game)
  #   {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  # end
  #
  # def handle_in("reset", %{"filler" => i}, socket) do
  #     name = socket.assigns[:name]
  #     game = Game.new()
  #     socket = assign(socket, :game, game)
  #     BackupAgent.put(name, game)
  #     {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  #   end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
