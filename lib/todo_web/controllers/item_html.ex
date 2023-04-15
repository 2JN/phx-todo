defmodule TodoWeb.ItemHTML do
  use TodoWeb, :html

  import Phoenix.HTML.Form

  embed_templates("item_html/*")

  @doc """
  Renders a item form.
  """
  attr(:changeset, Ecto.Changeset, required: true)
  attr(:action, :string, required: true)

  def item_form(assigns)

  def complete(item) do
    case item.status do
      1 -> "completed"
      _ -> ""
    end
  end

  def remaining_items(items) do
    Enum.filter(items, fn i -> i.status == 0 end)
    |> Enum.count()
  end
end
