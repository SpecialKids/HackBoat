defmodule HackBoat.Elixir.Eval do
  @moduledoc """
  Contains Functions for the evaluation of Elixir Code.
  """

  import Alchemy.Embed
  import HackBoat.Embeds
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
        HackBoat.Embeds.eval_result(code, Macro.to_string(result), "elixir", "Elixir Evaluation", thumb)
        |> Cogs.send

      nil ->
       HackBoat.Embeds.title_only("Evaluation of Elixir exceeded the 5 second time limit.", "red")
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
    HackBoat.Embeds.title("Eval requires Code to execute.", "red")
    |> Cogs.send
  end

  @doc false
  Cogs.def ping, do: Cogs.say("pong")
end  # Commands
