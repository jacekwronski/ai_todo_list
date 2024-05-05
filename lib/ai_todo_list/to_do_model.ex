defmodule AiTodoList.Model do
  # defp load() do
  #   {:ok, embedding_model} = Bumblebee.load_model({:hf, "facebook/bart-large-cnn"})
  #   {:ok, embedding_tokenizer} = Bumblebee.load_tokenizer({:hf, "facebook/bart-large-cnn"})

  #   # {:ok, embedding_model} = Bumblebee.load_model({:hf, "DeepMount00/Mistral-Ita-7b"})
  #   # {:ok, embedding_tokenizer} = Bumblebee.load_tokenizer({:hf, "DeepMount00/Mistral-Ita-7b"})

  #   # {:ok, embedding_model} = Bumblebee.load_model({:hf, "intfloat/multilingual-e5-large"})
  #   # {:ok, embedding_tokenizer} = Bumblebee.load_tokenizer({:hf, "intfloat/multilingual-e5-large"})

  #   {embedding_model, embedding_tokenizer}
  # end

  defp load() do
    {:ok, embedding_model} = Bumblebee.load_model({:hf, "setu4993/LEALLA-large"})
    {:ok, embedding_tokenizer} = Bumblebee.load_tokenizer({:hf, "setu4993/LEALLA-large"})

    # {:ok, embedding_model} = Bumblebee.load_model({:hf, "DeepMount00/Mistral-Ita-7b"})
    # {:ok, embedding_tokenizer} = Bumblebee.load_tokenizer({:hf, "DeepMount00/Mistral-Ita-7b"})

    # {:ok, embedding_model} = Bumblebee.load_model({:hf, "intfloat/multilingual-e5-large"})
    # {:ok, embedding_tokenizer} = Bumblebee.load_tokenizer({:hf, "intfloat/multilingual-e5-large"})

    {embedding_model, embedding_tokenizer}
  end

  # def serving_generation(opts \\ []) do
  #   opts = Keyword.validate!(opts, [:defn_options, sequence_length: 64, batch_size: 16])
  #   {defn_opts, compile_opts} = Keyword.pop!(opts, :defn_options)
  #   opts = [defn_options: defn_opts, compile: compile_opts]

  #   {embedding_model, embedding_tokenizer} = load()
  #   {:ok, generation_config} = Bumblebee.load_generation_config({:hf, "facebook/bart-large-cnn"})

  #   IO.inspect(generation_config)

  #   config =
  #     Bumblebee.configure(generation_config,
  #       max_new_tokens: 30,
  #       strategy: %{type: :contrastive_search, top_k: 4, alpha: 0.6}
  #     )

  #   IO.inspect(%{config | min_length: 10})

  #   Bumblebee.Text.TextGeneration.generation(
  #     embedding_model,
  #     embedding_tokenizer,
  #     %{config | min_length: 10},
  #     opts
  #   )
  # end

  def serving(opts \\ []) do
    opts = Keyword.validate!(opts, [:defn_options, sequence_length: 64, batch_size: 16])
    {defn_opts, compile_opts} = Keyword.pop!(opts, :defn_options)
    opts = [defn_options: defn_opts, compile: compile_opts]

    {embedding_model, embedding_tokenizer} = load()
    Bumblebee.Text.TextEmbedding.text_embedding(embedding_model, embedding_tokenizer, opts)
  end

  def predict(text) do
    Nx.Serving.batched_run(AiTodoListModel, text)
  end

  # def predict_generate(text) do
  #   Nx.Serving.batched_run(AiTodoListGenerationModel, text)
  # end
end
