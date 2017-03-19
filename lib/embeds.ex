defmodule HackBoat.Embeds do
  @moduledoc false
  # Provides Functions to ease the creation of Embeds.

  import Alchemy.Embed

  @doc false
  #### color_picker/1
  ## Get an integer representing a colour based on the input name.
  #
  ## Arguments
  #    - color_name: String denoting the Color Name.
  #
  ## Example
  #    pick_colour("red")
  defp pick_colour(color_name) do
    case color_name do
      "red" -> 0xCC0000
      "blue" -> 0x446BEB
      "green" -> 0x39DB4C
      "pink" -> 0xDA2FE0
      "brown" -> 0xE0822F
    end
  end

  @doc false
  ### code_block/1
  ## Create a Code Block.
  #
  ## Arguments
  #    - code: String containing the Code which should be put in the Code block.
  #
  ## Example
  #    code_block("2 + 2")
  defp code_block(code) do
    "```\n#{code}\n```"
  end

  @doc false
  #### code_block/2
  ## Create a Code Block with Syntax Highlighting.
  #
  ## Arguments
  #    - lang: String denoting the Language for which the Code Block should be created.
  #    - code: String containing the Code that should be put in the Code block.
  #
  ## Example
  #    code_block("python", "print('hello world')")
  defp code_block(lang, code) do
    "```#{lang}\n#{code}\n```"
  end

  @doc false
  #### title_only/1
  ## Create an Embed containing just a Title.
  #
  ## Arguments
  #    - title: String specifying the Title
  #
  ## Example
  #    title_only("Hello!")
  def title_only(title) do
    %Alchemy.Embed{}
    |> title(title)
  end

  @doc false
  #### title_only/2
  ## Create a colored Embed with just a Title.
  #
  ## Arguments
  #    - title: String specifying the Title
  #    - color_name: String denoting the Color to be used.
  #
  ## Example
  #     title_only("Error", "red")
  def title_only(title, color_name) do
    %Alchemy.Embed{}
    |> title(title)
    |> color(pick_colour(color_name))
  end

  @doc false
  #### auto_field/2
  ## Create an Embed that adds a number of fields based on the given input.
  #
  ## Arguments
  #  - title: String specifying the Title of the Embed
  #  - information: An Array containing Objects denoting field's titles and descriptions
  #
  ## Example
  #    auto_field_embed("Lots of Things", [ {"thing one", "describe thing one"}, {"thing two", "describe thing two"} ])
  def auto_field(title, information) do
    Enum.reduce(information, %Alchemy.Embed{}, fn {name, value}, embed ->
      field(embed, name, value)
    end)
    |> title(title)
  end

  @doc false
  #### eval_result/1
  ## Create an Embed to display Code Evaluation Results.
  #
  ## Arguments
  #    - output: String containing the Evaluation result.
  #
  ## Example
  #    eval_result("Hello World")
  def eval_result(output) do
    %Alchemy.Embed{}
    |> field("Output:", code_block(output))
  end

  @doc false
  #### eval_result/2
  ## Create an Embed to display Code Evaluation Results and Input.
  #
  ## Arguments
  #    - input: String containing the inputted Code.
  #    - output: String containing the Evaluation result.
  #
  ## Example
  #    eval_result("print('hello world')", "'hello world'")
  def eval_result(input, output) do
    %Alchemy.Embed{}
    |> field("Input:", code_block(input))
    |> field("Output:", code_block(output))
  end

  @doc false
  #### eval_result/3
  ## Create an Embed with Syntax Highlighting to display Code Evaluation Results and Input.
  #
  ## Arguments
  #    - input: String containing the inputted Code.
  #    - output: String containing the Evaluation result.
  #    - lang: String denoting the used language.
  #
  ## Example
  #    eval_result("print('hello world')", "'hello world'", "python")
  def eval_result(input, output, lang) do
    %Alchemy.Embed{}
    |> field("Input:", code_block(lang, input))
    |> field("Output:", code_block(lang, output))
  end

  @doc false
  #### eval_result/4
  ## Create an Embed with Syntax Highlighting and a custom Footer Text to display Code Evaluation Results and Input.
  #
  ## Arguments
  #    - input: String containing the inputted Code.
  #    - output: String containing the Evaluation result.
  #    - lang: String denoting the used language.
  #    - footer_text: String denoting what to put in the Footer.
  #
  ## Example
  #    eval_result("print('hello world')", "'hello world'", "python", "Python 2.7 Evaluation")
  def eval_result(input, output, lang, footer_text) do
    %Alchemy.Embed{}
    |> field("Input:", code_block(lang, input))
    |> field("Output:", code_block(lang, output))
    |> footer(icon_url: "", text: footer_text)
  end

  @doc false
  #### eval_result/5
  ## Create an Embed with Syntax Highlighting and a custom Footer Text to display Code Evaluation Results and Input.
  #
  ## Arguments
  #    - input: String containing the inputted Code.
  #    - output: String containing the Evaluation result.
  #    - lang: String denoting the used language.
  #    - footer_text: String denoting what to put in the Footer.
  #    - footer_img: String denoting the URL for an Image to be put in the Footer.
  #
  ## Example
  #    eval_result("print('hello world')", "'hello world'", "python", "Python 2.7 Evaluation", "<python-logo-image>")
  def eval_result(input, output, lang, footer_text, footer_img) do
    %Alchemy.Embed{}
    |> field("Input:", code_block(lang, input))
    |> field("Output:", code_block(lang, output))
    |> footer(icon_url: footer_img, text: footer_text)
  end
end