defmodule Cruncher.Counter do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def reset() do
    Agent.update(__MODULE__, fn _ -> 0 end)
  end

  def increment() do
    Agent.update(__MODULE__, &(&1 + 1))
  end

  def decrement() do
    Agent.update(__MODULE__, &(&1 - 1))
  end

  def get() do
    Agent.get(__MODULE__, &(&1))
  end
end
