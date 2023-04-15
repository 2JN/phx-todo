defmodule Todo.Helpers do
  def toggle_status(item) do
    case item.status do
      0 -> 1
      1 -> 0
    end
  end
end
