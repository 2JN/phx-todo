defmodule Todo.List.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :person_id, :status, :text, :due_date]}
  schema "items" do
    field(:person_id, :integer, default: 0)
    field(:status, :integer, default: 0)
    field(:text, :string)
    field(:due_date, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:text, :person_id, :status, :due_date])
    |> validate_required([:text])
  end
end
