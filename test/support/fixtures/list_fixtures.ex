defmodule Todo.ListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.List` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        person_id: 42,
        status: 0,
        text: "some text"
      })
      |> Todo.List.create_item()

    item
  end
end
