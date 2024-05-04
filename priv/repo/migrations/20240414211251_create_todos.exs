defmodule AiTodoList.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :text, :string
      add :completed, :boolean, default: false, null: false
      add :embedding, :vector, size: 256

      timestamps(type: :utc_datetime)
    end
  end
end
