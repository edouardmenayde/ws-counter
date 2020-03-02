defmodule Cruncher.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      Cruncher.SocketHandler,
      Cruncher.Counter,
      Cruncher.Path
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
