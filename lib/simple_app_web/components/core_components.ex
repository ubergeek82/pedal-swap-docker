defmodule SimpleAppWeb.CoreComponents do
  use Phoenix.Component

  slot :inner_block, required: true

  def flash(assigns) do
    ~H"""
    <div class="fixed top-4 right-4 z-50">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end