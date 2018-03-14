defmodule Vitalstatistix.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest Vitalstatistix

  defmodule Dummy do
    def log_filter(%Plug.Conn{method: "GET", request_path: "/_ping"}), do: false
    def log_filter(_), do: true
  end

  test "hooks itself on before_send" do
    assert %Plug.Conn{before_send: [_fun]} = conn(:get, "/") |> Vitalstatistix.Plug.call([])
  end

  test "before_send executes with logging disabled" do
    conn(:get, "/")
    |> Vitalstatistix.Plug.call(log_if: fn _ -> false end)
    |> exec_before_send
  end

  test "before_send executes with logging enabled" do
    conn(:get, "/")
    |> Vitalstatistix.Plug.call(log_if: fn _ -> true end)
    |> exec_before_send
  end

  test "before_send executes with logging controlled by {mod, function}" do
    conn(:get, "/")
    |> Vitalstatistix.Plug.call(log_if: {Dummy, :log_filter})
    |> exec_before_send
    # this should not log
    conn(:get, "/_ping")
    |> Vitalstatistix.Plug.call(log_if: {Dummy, :log_filter})
    |> exec_before_send
  end

  def exec_before_send(%Plug.Conn{before_send: before_send} = conn), do: exec_before_send(conn, before_send)

  def exec_before_send(_conn, []), do: nil

  def exec_before_send(conn, [fun | tl]) do
    fun.(conn)
    exec_before_send(conn, tl)
  end
end
