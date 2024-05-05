defmodule AiTodoListWeb.TodoLive.FormComponent do
  use AiTodoListWeb, :live_component

  alias AiTodoList.Todos
  alias AiTodoList.ActionsModel

  @impl true
  def render(assigns) do
    ~H"""
    <div class="todo-form">
      <.simple_form for={@form} id="todo-form" phx-target={@myself} phx-submit="save">
        <.input field={@form[:text]} type="text" label="Text" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Todo</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  # phx-change="validate"
  @impl true
  def update(%{todo: todo} = assigns, socket) do
    changeset = Todos.change_todo(todo, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("save", %{"todo" => todo_params}, socket) do
    %{"text" => text} = todo_params
    %{predictions: [%{label: label} | _]} = ActionsModel.predict_action(text)
    IO.inspect(label, label: "PREVISIONE")

    case label do
      "Add item" -> save_todo(socket, :new, todo_params)
      "Completed" -> save_todo(socket, :done, text)
      "Delete" -> delete_todo(socket, text)
    end
  end

  defp save_todo(socket, :done, todo_params) do
    case Todos.todo_is_done(todo_params) do
      {:ok, todo} ->
        notify_parent({:saved, todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo marked as done successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_todo(socket, :new, todo_params) do
    case Todos.create_todo(todo_params) do
      {:ok, todo} ->
        notify_parent({:saved, todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp delete_todo(socket, text) do
    case Todos.delete(text) do
      {:ok, todo} ->
        notify_parent({:deleted, todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo deleted successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
