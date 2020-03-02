defmodule Cruncher.Path do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def set(path) do
    Agent.update(__MODULE__, fn _ -> path end)
  end

  def get() do
    Agent.get(__MODULE__, &(&1))
  end
end

