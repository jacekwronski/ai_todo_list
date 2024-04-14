defmodule AiTodoList.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :completed, :boolean, default: false
    field :embedding, :binary
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:text, :completed, :embedding])
    |> validate_required([:text, :completed, :embedding])
  end
end
