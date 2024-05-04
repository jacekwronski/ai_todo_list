defmodule AiTodoList.ActionsModel do
  defp load() do
    {:ok, model} = Bumblebee.load_model({:hf, "facebook/bart-large-mnli"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "facebook/bart-large-mnli"})

    # {:ok, model} = Bumblebee.load_model({:hf, "Jiva/xlm-roberta-large-it-mnli"})
    # {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "Jiva/xlm-roberta-large-it-mnli"})

    {model, tokenizer}
  end

  def serving(_) do
    {model, tokenizer} = load()

    labels = ["Add item", "Completed", "Delete"]

    Bumblebee.Text.zero_shot_classification(
      model,
      tokenizer,
      labels
    )
  end

  def predict_action(text) do
    # %{predictions: [%{label: label} | _]}
    Nx.Serving.batched_run(AiTodoListActionsModel, text)
  end
end
