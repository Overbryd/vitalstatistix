defmodule Vitalstatistix do
  @moduledoc """
  Documentation for Vitalstatistix.
  """

  def start(_type, _args) do
    :ok = Vitalstatistix.Statsd.connect()
    :ok
  end
  # use Application

  # def start(_type, _args) do
  #   import Supervisor.Spec
  #   myhtml_worker = Path.join(:code.priv_dir(unquote(app)), "myhtml_worker")
  #   children = [
  #     worker(Nodex.Cnode, [%{exec_path: myhtml_worker}, [name: Myhtmlex.Safe.Cnode]])
  #   ]
  #   Supervisor.start_link(children, strategy: :one_for_one, name: Myhtmlex.Safe.Supervisor)
  # end

  def hello do
    :world
  end
end
