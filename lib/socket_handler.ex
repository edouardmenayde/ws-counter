defmodule Cruncher.SocketHandler do
  use Riverside, otp_app: :cruncher

  alias Cruncher.Counter

  @impl Riverside
  def handle_message(%{"client_id" => client_id, "event" => "increment"} = msg, session, state) do
    IO.inspect("Increment")
    IO.inspect(client_id)

    Counter.increment()

    IO.inspect(Counter.get())

    deliver_me(%{"count" => Counter.get()})

    {:ok, session, state}
  end
end
