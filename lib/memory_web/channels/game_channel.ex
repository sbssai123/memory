# This file was based heavily on the game_channel.ex game in the hangman
# we did in class.
defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.GameServer

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      GameServer.add_user(game, socket.assigns[:user])
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"tile_index" => i}, socket) do
    view = GameServer.click(socket.assigns[:game], socket.assigns[:user], i)
    broadcast(socket, "change_view", view)
    {:reply, {:ok, %{ "game" => view}}, socket}
  end

  def handle_in("match", %{"tile_index" => i}, socket) do
    view = GameServer.match(socket.assigns[:game], socket.assigns[:user], i)
    broadcast(socket, "change_view", view)
    {:reply, {:ok, %{ "game" => view}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
