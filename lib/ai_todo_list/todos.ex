defmodule AiTodoList.Todos do
  @moduledoc """
  The Todos context.
  """

  import Pgvector.Ecto.Query
  import Ecto.Query, warn: false
  alias AiTodoList.Repo

  alias AiTodoList.Todos.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Todo.put_embedding()
    |> Repo.insert()
  end

  def todo_is_done(text) do
    embedding = AiTodoList.Model.predict(text)

    todo =
      Todo
      |> order_by([b], l2_distance(b.embedding, ^embedding.embedding))
      |> limit(1)
      |> Repo.one()

    # new_todo = %{todo | completed: true}

    todo
    |> Todo.changeset(%{completed: true})
    |> Repo.update()
  end

  def delete(text) do
    embedding = AiTodoList.Model.predict(text)

    todo =
      Todo
      |> order_by([b], l2_distance(b.embedding, ^embedding.embedding))
      |> limit(1)
      |> Repo.one()

    # new_todo = %{todo | completed: true}

    todo
    |> Repo.delete()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(nil, attrs) do
    Todo.changeset(%Todo{}, attrs)
  end

  def change_todo(%Todo{} = todo, attrs) do
    Todo.changeset(todo, attrs)
  end

  def search(query) do
    embedding = AiTodoList.Model.predict(query)

    Todo
    |> order_by([b], l2_distance(b.embedding, ^embedding.embedding))
    |> limit(5)
    |> Repo.all()
  end
end
