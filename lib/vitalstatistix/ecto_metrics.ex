defmodule Vitalstatistix.EctoMetrics do
  @moduledoc """
  Provide per query statistics.

  Configure like this in your config/config.exs

  config :myapp, MyApp.Repo,
    loggers: [{Ecto.LogEntry, :log, []}, {Vitalstatistix.EctoMetrics, :log, []}]
  """

  alias Vitalstatistix.Statsd

  def log(entry) do
    queue_time = (entry.queue_time || 0) / 1000
    exec_time = entry.query_time / 1000 + queue_time
    Statsd.timing("ecto.query_exec.time", exec_time)
    Statsd.timing("ecto.query_queue.time", queue_time)
    {result, _} = entry.result
    Statsd.increment("ecto.query_count.#{result}", 1)
  end

end
