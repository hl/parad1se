defmodule ParadiseWeb.AstronautDashboardLive do
  use ParadiseWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="messages" role="log" aria-live="polite"></div>
    <input id="chat-input" type="text" />
    """
  end

  def mount(_params, _assigns, socket) do
    {:ok, socket}
  end
end
