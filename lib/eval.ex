defmodule HackBoat.Elixir.Eval do
  @moduledoc """
  Contains Functions for the evaluation of Elixir Code.
  """

  import Alchemy.Embed
  use Alchemy.Cogs
  use Application

  @valid_ids Application.fetch_env!(:hackBoat, :authorized)

  @doc false
  #### evaluate_elixir/2
  ## Evaluate a snippet of Elixir Code.
  #
  # ## Parameters
  #    - message: The original Alchemy.Message which invoked the Command
  #    - code: String containing the Elixir Code to be executed
  def evaluate_elixir(message, code) do
       try do
         {result, _} = Code.eval_string(code, [message: message], __ENV__)
         result
       rescue
         e -> e
       end
   end

  @doc false
  #### eval_error_embed/2
  ## Create a simple Embed with red Colour and short text.
  #
  ## Parameters
  #  - error_message: String denoting the Message of what went wrong
  #  - thumbnail: Optional Link for a thumbnail to be shown within the Embed
  #
  ## Examples
  #    eval_error_embed("Evaluation of Elixir exceeded 5 second time limit.")
  #   eval_error_embed("You are not allowed to use this Command.")
  def eval_error_embed(error_message, thumbnail \\ nil) do
    maybe_thumbnail = case thumbnail do
      nil -> fn e -> e end
      link -> fn e -> thumbnail(e, link) end
    end

    %Alchemy.Embed{}
    |> title(error_message)
    |> maybe_thumbnail.()
    |> color(0xCC0000)
  end

  @doc false
  #### eval_embed/6
  ## Create an embedded Message displaying the Input and Output of Code Evaluation
  #
  ## Parameters
  #  - input: String that contains the code that was given
  #  - output: String that contains the Result of input's Execution
  #  - lang: String that specifies the Language that was used for Execution
  #  - message: The original Message that invoked the Evaluation
  #  - thumbnail: String that can optionally denote an image to display in the Embed
  #  - admin_mode: Boolean that specifies whether the User which invoked the Command is authorized or not
  def eval_embed(input, output, lang, message, thumbnail \\ nil, admin_mode \\ false, color) do
     maybe_thumbnail = case thumbnail do
       nil -> fn e -> e end
       link -> fn e -> thumbnail(e, link) end
     end

     maybe_admin = case admin_mode do
       true ->
         & footer(&1, text: "Authorized User | #{String.capitalize(lang)} Evaluation",
                      icon_url: message.author |> Alchemy.User.avatar_url)
       false ->
         & footer(&1, text: "#{String.capitalize(lang)} Evaluation")
     end
     code_block = fn code ->
       "```#{lang}\n#{code}\n```"
     end
     %Alchemy.Embed{}
     |> maybe_thumbnail.()
     |> maybe_admin.()
     |> field("Input:", code_block.(input))
     |> field("Output:", code_block.(output))
     |> color(color)
  end

  # Set a Parser to extract Code from Codeblocks
  Cogs.set_parser(:eval, fn string ->
   string
   |> String.split(["```", "\n", "\n```"])
   |> Enum.drop(1)
   end)

  @doc """
  Evaluates Elixir Code.

  ## Usage
      !eval \`\`\`elixir
      2 + 2
      \`\`\`

  """
  #### cmd: !eval ```elixir <code>```
  ## Evaluate a Code Snippet in Elixir
  #
  ## Parameters
  #  - code: String that contains the Users codeblock
  #
  ## Example
  #    !eval \`\`\`elixir
  #    2 + 2
  #    \`\`\`
  Cogs.def eval("elixir", code) do
    thumb = "https://avatars2.githubusercontent.com/u/1481354?v=3&s=400"
    if message.author.id in @valid_ids do
      task = Task.async(fn ->
        evaluate_elixir(message, code)
      end)

      case Task.yield(task) || Task.shutdown(task) do
      {:ok, result} ->
        eval_embed(code, Macro.to_string(result), "elixir", message, thumb, true, 0x370C56)
        |> Cogs.send

      nil ->
       eval_error_embed("Evaluation of Elixir exceeded 5 second time limit.")
       |> Cogs.send
      end
    end
  end

  @doc """
  Information Command to inform you about not passing any Code to be executed.

  ## Example
      !eval
  """
  Cogs.def eval do
    eval_error_embed("Eval requires Code to execute.")
    |> Cogs.send
  end

  @doc false
  Cogs.def ping, do: Cogs.say("pong")
end  # Commands
