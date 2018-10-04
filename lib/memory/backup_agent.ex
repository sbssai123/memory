# This file was used from the Hangman example in class:
# https://github.com/NatTuck/hangman/blob/8888bba5c6a9850191ef4957211aba43c158780b/lib/hangman/backup_agent.ex
defmodule Memory.BackupAgent do
  use Agent

  # This is basically just a global mutable map.
  # TODO: Add timestamps and expiration.

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(name, val) do
    Agent.update __MODULE__, fn state ->
      Map.put(state, name, val)
    end
  end

  def get(name) do
    Agent.get __MODULE__, fn state ->
      Map.get(state, name)
    end
  end
end
