defmodule TodoWeb.ItemController do
  use TodoWeb, :controller

  alias Todo.List
  alias Todo.Helpers
  alias Todo.List.Item

  def index(conn, params) do
    item =
      if not is_nil(params) and Map.has_key?(params, "id") do
        List.get_item!(params["id"])
      else
        %Item{}
      end

    items = List.list_items()
    changeset = List.change_item(item)
    render(conn, :index, items: items, changeset: changeset, editing: item)
  end

  def new(conn, _params) do
    changeset = List.change_item(%Item{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case List.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: ~p"/items")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = List.get_item!(id)
    render(conn, :show, item: item)
  end

  def edit(conn, params) do
    index(conn, params)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = List.get_item!(id)

    case List.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: ~p"/items")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = List.get_item!(id)
    {:ok, _item} = List.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: ~p"/items")
  end

  def toggle(conn, %{"id" => id}) do
    item = List.get_item!(id)
    List.update_item(item, %{status: Helpers.toggle_status(item)})

    conn
    |> redirect(to: ~p"/items")
  end
end
