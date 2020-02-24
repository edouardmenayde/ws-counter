defmodule Cruncher do
  use Application

  def start(_type, _args) do
    [
       {Riverside, [handler: Cruncher.SocketHandler]}
    ]
    |> Supervisor.start_link([
      strategy: :one_for_one,
      name:     Cruncher.Supervisor
    ])
  end
end
