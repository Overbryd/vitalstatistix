defmodule Vitalstatistix.Plug do
  @moduledoc """
  Provide per request statistics.
  """

  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  alias Vitalstatistix.Statsd

  require Logger

  def init([]), do: []

  def call(conn, _config) do
    started_at = System.monotonic_time(:microseconds)
    Statsd.increment("plug.request.#{String.downcase(conn.method)}", 1)
    register_before_send(conn, fn conn ->
      ended_at = System.monotonic_time(:microseconds)
      duration = (ended_at - started_at) / 1000
      Statsd.increment("plug.response.#{conn.status}", 1)
      Statsd.timing("plug.request_response.time", duration)
      Logger.info "\"#{conn.method} #{conn.request_path}\" #{conn.status}", [time_ms: duration]
      conn
    end)
  end

end

