defmodule Blinky.Blink do
  use GenServer

  def start_link() do
      GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, pid} = ElixirALE.GPIO.start_link(26, :output)
    Process.send_after(self(), :blink_on, 500)
    {:ok, pid}
  end

  def handle_info(:blink_on, pid) do
    ElixirALE.GPIO.write(pid, 1)
    Process.send_after(self(), :blink_off, 1000)
    {:noreply, pid}
  end

  def handle_info(:blink_off, pid) do
    ElixirALE.GPIO.write(pid, 0)
    Process.send_after(self(), :blink_on, 1000)
    {:noreply, pid}
  end

end
