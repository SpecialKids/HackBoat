defmodule HackBoat.Elixir.Eval do
  import Alchemy.Embed
  import Alchemy.User
  use Alchemy.Cogs


  @valid_ids ["196989358165852160, 197177484792299522"]

  def evaluate_elixir(message, code) do
       result = try do
         {result, _} = Code.eval_string(code, [message: message], __ENV__)
         result
       rescue
         e -> e
       end
   end

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

  def eval_embed(input, output, lang, message, thumbnail \\ nil, admin_mode \\ false) do
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
  end

  # Parser for eval
  Cogs.set_parser(:eval, fn string ->
   string
   |> String.split(["```", "\n", "\n```"])
   |> Enum.drop(1)
   end)

  @doc """
   Evaluate a Code Snippet in Elixir

   code: Snippet to be executed
  """
  Cogs.def eval("elixir", code) do
    thumb = "https://avatars2.githubusercontent.com/u/1481354?v=3&s=400"
    if message.author.id in @valid_ids do
      task = Task.async(fn ->
        evaluate_elixir(message, code)
      end)

      case Task.yield(task) || Task.shutdown(task) do
      {:ok, result} ->
        embed = eval_embed(code, Macro.to_string(result), "elixir", message, thumb, true)
        |> Cogs.send

      nil ->
       embed = eval_error_embed("Evaluation of Elixir exceeded 5 second time limit.")
       |> Cogs.send
      end
    end
  end

  Cogs.def eval do
    embed = eval_error_embed("Eval requires Code to execute.")
    |> Cogs.send
  end

  Cogs.def ping, do: Cogs.say("pong")
end  # Commands
