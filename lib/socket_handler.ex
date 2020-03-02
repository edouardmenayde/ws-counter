defmodule Cruncher.SocketHandler do
  use Riverside, otp_app: :cruncher

  alias Cruncher.Counter
  alias Cruncher.Path

  @main_channel "main"
  @token "QP4FAg3TakcxS68B8ekD"

  @impl Riverside
  def init(session, state) do
    Riverside.LocalDelivery.join_channel(@main_channel)
    deliver_current_connections(session, state)
  end

  @impl Riverside
  def handle_message(%{"event" => "get_connections"}, session, state) do
    deliver_current_connections(session, state)
  end

  @impl Riverside
  def handle_message(%{"event" => "set_path", "path" => path, "token" => token}, session, state) do
    if token == @token do
      Path.set(path)
    end

    deliver_current_path(session, state)
  end

  @impl Riverside
  def handle_message(%{"event" => "get_path"}, session, state) do
    deliver_current_path(session, state)
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

  defp deliver_current_path(session, state) do
    outgoing = %{"path" => Path.get()}

    deliver_channel(@main_channel, outgoing)

    {:ok, session, state}
  end

  defp deliver_current_connections(session, state) do
    outgoing = %{"connections" => Riverside.MetricsInstrumenter.number_of_current_connections()}

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
    outgoing = %{"connections" => Riverside.MetricsInstrumenter.number_of_current_connections() - 1}

    deliver_channel(@main_channel, outgoing)

    :ok
  end
end
