defmodule TcpServer do
  @moduledoc """
  Documentation for `TcpServer`.
  # Build a tcp server and understand
  # It should accept connection and return response
  # It should handle multiple connects synchronously
  #
  """
  require Logger
  @port 3000

  def run do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{@port}")
    pid = Client.start()
    listen(pid, socket)
  end

  def listen(pid, socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve_async(pid, client)
    listen(pid, socket)
  end

  def serve_async(pid, client) do
    # store client
    spawn(fn -> serve(pid, client) end )
  end

  def serve(pid, client) do
    :ok = Client.add_client(pid, client)

    client
    |> read_line()
    |> write_line(pid)
  end

  def write_line(line, pid) do
     Client.list_clients(pid)
     |> Enum.each(&:gen_tcp.send(&1, line))
  end

  def read_line(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)
    data
  end

end
