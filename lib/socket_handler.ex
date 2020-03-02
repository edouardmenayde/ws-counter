defmodule Cruncher.SocketHandler do
  use Riverside, otp_app: :cruncher

  alias Cruncher.Counter

  @main_channel "main"

  @impl Riverside
  def init(session, state) do
    Riverside.LocalDelivery.join_channel(@main_channel)
    {:ok, session, state}
  end

  @impl Riverside
  def handle_message(%{"event" => "increment"}, session, state) do
    Counter.increment()

    deliver_current_count(session, state)
  end

  @impl Riverside
  def handle_message(%{"event" => "decrement"}, session, state) do
    Counter.decrement()
    deliver_current_count(session, state)
  end

  @impl Riverside
  def handle_message(%{"event" => "get"}, session, state) do
    deliver_current_count(session, state)
  end

  @impl Riverside
  def handle_message(%{"event" => "reset"}, session, state) do
    Counter.reset()

    deliver_current_count(session, state)
  end

  defp deliver_current_count(session, state) do
    outgoing = %{"count" => Counter.get()}

    deliver_channel(@main_channel, outgoing)

    {:ok, session, state}
  end

  @impl Riverside
  def handle_info(_info, session, state) do
    {:ok, session, state}
  end

  @impl Riverside
  def terminate(_reason, _session, _state) do
    leave_channel(@main_channel)
    :ok
  end
end
