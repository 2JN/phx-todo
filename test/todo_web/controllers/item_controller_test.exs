defmodule TodoWeb.ItemControllerTest do
  use TodoWeb.ConnCase

  alias Todo.List
  import Todo.ListFixtures

  @create_attrs %{person_id: 42, status: 0, text: "some text"}
  @public_create_attrs %{person_id: 0, status: 0, text: "some public text"}
  @completed_attrs %{person_id: 42, status: 1, text: "some text completed"}
  @public_completed_attrs %{person_id: 0, status: 1, text: "some text completed"}
  @update_attrs %{person_id: 43, status: 1, text: "some updated text"}
  @invalid_attrs %{person_id: nil, status: nil, text: nil}

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, ~p"/items")
      assert html_response(conn, 200) =~ "todos"
    end

    test "lists items in filter", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @public_create_attrs)

      conn = get(conn, ~p"/items/filter/active")
      assert html_response(conn, 200) =~ @public_create_attrs.text

      conn = get(conn, ~p"/items/filter/completed")
      refute html_response(conn, 200) =~ @public_create_attrs.text
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/items/new")
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @create_attrs)

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/items"

      conn = get(conn, ~p"/items")
      assert html_response(conn, 200) =~ "Item"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get(conn, ~p"/items/#{item}/edit")
      assert html_response(conn, 200) =~ "Click here to create a new item"
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @update_attrs)
      assert redirected_to(conn) == ~p"/items"

      conn = get(conn, ~p"/items")
      assert html_response(conn, 200) =~ "some updated text"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, ~p"/items/#{item}")
      assert redirected_to(conn) == ~p"/items"

      assert_error_sent(404, fn ->
        get(conn, ~p"/items/#{item}")
      end)
    end
  end

  describe "toggle updates the status of an item 0 > 1 | 1 > 0" do
    setup [:create_item]

    test "toggle_status/1 item.status 1 > 0", %{item: item} do
      assert item.status == 0

      toggled_item = %{item | status: Todo.Helpers.toggle_status(item)}
      assert toggled_item.status == 1
      assert Todo.Helpers.toggle_status(toggled_item) == 0
    end

    test "toggle/2 updates an item.status 0 > 1", %{conn: conn, item: item} do
      assert item.status == 0
      get(conn, ~p"/items/toggle/#{item.id}")
      toggled_item = List.get_item!(item.id)
      assert toggled_item.status == 1
    end
  end

  describe "clear completed" do
    setup [:create_item]

    test "clears the completed items", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @public_completed_attrs)
      conn = get(conn, ~p"/items/clear")

      completed_item = Enum.at(conn.assigns.items, 1)

      assert conn.assigns.filter == "all"
      assert completed_item.status == 2
    end

    test "clears the completed items in public (person_id=0)", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @public_completed_attrs)
      conn = get(conn, ~p"/items/clear")

      completed_item = Enum.at(conn.assigns.items, 1)

      assert conn.assigns.filter == "all"
      assert completed_item.status == 2
    end
  end

  describe "footer" do
    setup [:create_item]

    test "hides footer", %{conn: conn} do
      conn = get(conn, ~p"/items")

      refute html_response(conn, 200) =~ "items left"
    end

    test "shows footer", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @public_completed_attrs)
      conn = get(conn, ~p"/items")

      assert html_response(conn, 200) =~ "item left"
    end
  end

  defp create_item(_) do
    item = item_fixture(@create_attrs)
    %{item: item}
  end
end
