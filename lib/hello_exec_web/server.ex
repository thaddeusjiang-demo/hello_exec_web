defmodule HelloExecWeb.Server do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Process.flag(:trap_exit, true)

    {:ok, pid} = ElixirKit.start()
    ref = Process.monitor(pid)

    ElixirKit.publish("log", "HelloExecWeb Phoenix server started!")

    {:ok, %{ref: ref}}
  end

  @impl true
  def handle_info({:event, name, message}, state) do
    IO.puts("[HelloExecWeb.Server] Received event: #{name} - #{message}")
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, reason}, state) when ref == state.ref do
    IO.puts("[HelloExecWeb.Server] ElixirKit process down: #{inspect(reason)}")

    case reason do
      :shutdown ->
        IO.puts("[HelloExecWeb.Server] Graceful shutdown")
        {:stop, :shutdown, state}

      _ ->
        IO.puts("[HelloExecWeb.Server] Unexpected termination, attempting restart...")
        # Try to restart ElixirKit connection
        case ElixirKit.start() do
          {:ok, pid} ->
            new_ref = Process.monitor(pid)
            ElixirKit.publish("log", "HelloExecWeb Phoenix server reconnected!")
            {:noreply, %{ref: new_ref}}

          {:error, error} ->
            IO.puts("[HelloExecWeb.Server] Failed to restart ElixirKit: #{inspect(error)}")
            {:stop, :restart_failed, state}
        end
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, reason}, state) do
    # Handle other monitored processes
    IO.puts("[HelloExecWeb.Server] Other process down: #{inspect(ref)} - #{inspect(reason)}")
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    IO.puts("[HelloExecWeb.Server] Stopping... Reason: #{inspect(reason)}")
  end
end
