#store clients
defmodule Client do
  def start do
    spawn(fn -> loop(%{}) end)
  end

  def loop(clients) do
    receive do
      {pid, :add_client, client} ->
        new_clients = Map.put(clients, pid, client)
        send(pid, {:ok, "sucessfully added"})
        loop(new_clients)
      {pid, :list_clients} ->
        send(pid, {:ok, :clients, Map.values(clients)})
        loop(clients)
    end
  end

  # client methods
  def add_client(pid, client) do
    send(pid, {self(), :add_client, client})
    receive do
      {:ok, _message} ->
        :ok
    end
  end

  def list_clients(pid) do
    send(pid, {self(), :list_clients})
    receive do
      {:ok, :clients, clients} ->
        clients
    end
  end
end
