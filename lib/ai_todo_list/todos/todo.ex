defmodule AiTodoList.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :completed, :boolean, default: false
    field :embedding, Pgvector.Ecto.Vector
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:text, :completed, :embedding])
    |> validate_required([:text])
  end

  def put_embedding(%{changes: %{text: text}} = todo_changeset) do
    embedding = AiTodoList.Model.predict(text)
    put_change(todo_changeset, :embedding, embedding.embedding)
  end
end
