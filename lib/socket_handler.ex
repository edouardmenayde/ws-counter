defmodule Cruncher.SocketHandler do
  use Riverside, otp_app: :cruncher

  @impl Riverside
  def handle_message(msg, session, state) do

    IO.inspect("Received")
    IO.inspect(msg)

    # `msg` is a 'TEXT' or 'BINARY' frame sent by client,
    # process it as you like
    deliver_me(msg)

    {:ok, session, state}
  end
end
