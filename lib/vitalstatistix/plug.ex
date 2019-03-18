defmodule Vitalstatistix.Plug do
  @moduledoc """
  Provide per request statistics.
  """

  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  alias Vitalstatistix.Statsd

  require Logger

  def init(opts), do: opts

  def call(conn, opts) do
    started_at = System.monotonic_time(:microsecond)
    Statsd.increment("plug.request.#{String.downcase(conn.method)}", 1)
    register_before_send(conn, fn conn ->
      ended_at = System.monotonic_time(:microsecond)
      duration = (ended_at - started_at) / 1000
      Statsd.increment("plug.response.#{conn.status}", 1)
      Statsd.timing("plug.request_response.time", duration)
      log(conn, duration, opts)
      conn
    end)
  end

  def log(conn, duration, opts) do
    log_condition = case Keyword.get(opts, :log_if) do
      {mod, function} -> apply(mod, function, [conn])
      fun when is_function(fun) -> fun.(conn)
      _ -> true
    end
    if log_condition do
      Logger.info "\"#{conn.method} #{conn.request_path}\" #{conn.status}", [time_ms: duration]
    end
  end

end

