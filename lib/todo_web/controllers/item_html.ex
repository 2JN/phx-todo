defmodule TodoWeb.ItemHTML do
  use TodoWeb, :html
  use Timex

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
    Enum.filter(items, &(&1.status == 0))
    |> Enum.count()
  end

  def filter(items, str) do
    case str do
      "items" -> Enum.filter(items, &(&1.status !== 2))
      "active" -> Enum.filter(items, &(&1.status == 0))
      "completed" -> Enum.filter(items, &(&1.status == 1))
      _ -> Enum.filter(items, &(&1.status !== 2))
    end
  end

  def pluralise(items) do
    case remaining_items(items) == 0 || remaining_items(items) > 1 do
      true -> "items"
      false -> "item"
    end
  end

  def got_items?(items) do
    Enum.filter(items, &(&1.status < 2)) |> Enum.count() > 0
  end

  def parse_date(date) do
    IO.puts(inspect(date))
    iso_date = DateTime.to_iso8601(date)

    {:ok, date} =
      Timex.parse!(iso_date, "{ISO:Extended}")
      |> Timex.format("{Mshort}, {0D} {YYYY} {h24}:{m}")

    date
  end
end
