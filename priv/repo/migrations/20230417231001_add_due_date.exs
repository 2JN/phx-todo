defmodule Todo.Repo.Migrations.AddDueDate do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add(:due_date, :utc_datetime)
    end
  end
end
