defmodule TodoWeb.ApiController do
  use TodoWeb, :controller
  alias Todo.List
  import Ecto.Changeset

  def index(conn, _params) do
    items = List.list_items()
    json(conn, items)
  end

  def create(conn, params) do
    case List.create_item(params) do
      {:ok, item} ->
        json(conn, item)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = make_errors_readable(changeset)

        json(
          conn |> put_status(400),
          errors
        )
    end
  end

  def update(conn, params) do
    id = Map.get(params, "id")
    text = Map.get(params, "text", "")

    item = List.get_item!(id)

    case List.update_item(item, %{text: text}) do
      {:ok, item} ->
        json(conn, item)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = make_errors_readable(changeset)

        json(
          conn |> put_status(400),
          errors
        )
    end
  end

  def update_status(conn, params) do
    id = Map.get(params, "id")
    status = Map.get(params, "status")

    item = List.get_item!(id)

    case List.update_item(item, %{status: status}) do
      {:ok, item} ->
        json(conn, item)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = make_errors_readable(changeset)

        json(
          conn |> put_status(400),
          errors
        )
    end
  end

  defp make_errors_readable(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
