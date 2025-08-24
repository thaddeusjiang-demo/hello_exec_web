defmodule HelloExecWebWeb.HomeLive do
  use HelloExecWebWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      ElixirKit.publish("web_ready", "Phoenix LiveView started!")
    end

    socket = assign(socket,
      message: "Hello from Phoenix LiveView!",
      counter: 0,
      logs: ["Phoenix LiveView started!"]
    )

    {:ok, socket}
  end

  def handle_event("increment", _params, socket) do
    new_counter = socket.assigns.counter + 1
    new_log = "Counter incremented to #{new_counter}"

    ElixirKit.publish("counter_update", new_log)

    socket = socket
    |> assign(counter: new_counter)
    |> assign(logs: [new_log | socket.assigns.logs])

    {:noreply, socket}
  end

  def handle_event("reset", _params, socket) do
    ElixirKit.publish("counter_reset", "Counter reset to 0")

    socket = socket
    |> assign(counter: 0)
    |> assign(logs: ["Counter reset to 0" | socket.assigns.logs])

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12 px-4">
      <div class="max-w-4xl mx-auto">
        <div class="text-center mb-12">
          <h1 class="text-5xl font-bold text-gray-900 mb-4">
            HelloExecWeb
          </h1>
          <p class="text-xl text-gray-600">
            Phoenix LiveView + ElixirKit Integration
          </p>
        </div>

        <div class="grid gap-8 md:grid-cols-2">
          <!-- Counter Section -->
          <div class="bg-white rounded-2xl shadow-xl p-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-6">Interactive Counter</h2>

            <div class="text-center mb-8">
              <div class="text-6xl font-bold text-indigo-600 mb-4">
                <%= @counter %>
              </div>
              <p class="text-gray-500">Current count</p>
            </div>

            <div class="flex gap-4 justify-center">
              <button
                phx-click="increment"
                class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-lg font-medium transition-colors"
              >
                Increment
              </button>
              <button
                phx-click="reset"
                class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-3 rounded-lg font-medium transition-colors"
              >
                Reset
              </button>
            </div>
          </div>

          <!-- Logs Section -->
          <div class="bg-white rounded-2xl shadow-xl p-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-6">Activity Logs</h2>

            <div class="bg-gray-50 rounded-lg p-4 h-64 overflow-y-auto">
              <%= for {log, index} <- Enum.with_index(@logs) do %>
                <div class={"mb-2 p-2 rounded text-sm #{if index == 0, do: "bg-indigo-100 text-indigo-800", else: "text-gray-600"}"}>
                  <span class="font-mono text-xs text-gray-400">
                    <%= Time.utc_now() |> Time.to_string() %>
                  </span>
                  <br>
                  <%= log %>
                </div>
              <% end %>
            </div>
          </div>
        </div>

        <!-- Status Section -->
        <div class="mt-8 bg-white rounded-2xl shadow-xl p-8">
          <h2 class="text-2xl font-semibold text-gray-800 mb-4">System Status</h2>
          <div class="grid gap-4 md:grid-cols-3">
            <div class="text-center p-4 bg-green-50 rounded-lg">
              <div class="text-green-600 font-semibold">Phoenix</div>
              <div class="text-sm text-green-600">Running</div>
            </div>
            <div class="text-center p-4 bg-blue-50 rounded-lg">
              <div class="text-blue-600 font-semibold">LiveView</div>
              <div class="text-sm text-blue-600">Connected</div>
            </div>
            <div class="text-center p-4 bg-purple-50 rounded-lg">
              <div class="text-purple-600 font-semibold">ElixirKit</div>
              <div class="text-sm text-purple-600">Active</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
