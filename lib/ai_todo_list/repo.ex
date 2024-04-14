defmodule AiTodoList.Repo do
  use Ecto.Repo,
    otp_app: :ai_todo_list,
    adapter: Ecto.Adapters.Postgres
end
