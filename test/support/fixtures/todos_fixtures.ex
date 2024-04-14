defmodule AiTodoList.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AiTodoList.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        completed: true,
        embedding: "some embedding",
        text: "some text"
      })
      |> AiTodoList.Todos.create_todo()

    todo
  end
end
