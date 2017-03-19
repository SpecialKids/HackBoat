defmodule HackBoat.Learn do
  @moduledoc """
  Provides Commands that provide Resources for learning Programming Languages.
  """

  use Alchemy.Cogs
  import Alchemy.Embed

  @doc false
  #### auto_field_embed/2
  ## Create an Embed that adds a number of fields based on the given input.
  #
  ## Arguments
  #  - title: String specifying the Title of the Embed
  #  - information: An Array containing Objects denoting field's titles and descriptions
  #
  ## Example
  #    auto_field_embed("Lots of Things", [ {"thing one", "describe thing one"}, {"thing two", "describe thing two"} ])
  def auto_field_embed(title, information) do
    Enum.reduce(information, %Alchemy.Embed{}, fn {name, value}, embed ->
      field(embed, name, value)
    end)
    |> title(title)
  end

  @doc false
  #### error_embed/1
  ## Create an Embed that shows a simple Error Message with the Color Red.
  #
  ## Arguments
  #  - error_message: String specifying the Error Message
  #
  ## Example
  #    error_embed("Don't do that!")
  def error_embed(error_message) do
      %Alchemy.Embed{}
      |> title(error_message)
      |> color(0xCC0000)
  end

  @doc false
  #### make_embed/2
  ## Create a simple Embed containing just a Title and a Description.
  #
  ## Arguments
  #  - title: String specifying the Title of the Embed
  #  - contents: String specifying the Contents of the Embed
  #
  ## Example
  #    make_embed("Weather for Wednesday", "Sunny")
  def make_embed(title, contents) do
    %Alchemy.Embed{}
    |> title(title)
    |> description(contents)
  end

  @doc false
  #### make_embed/3
  ## Create an Embed containing Title, Description, and a Thumbnail.
  #
  ## Arguments
  #  - title: String specifying the Title of the Embed
  #  - contents: String specifying the Contents of the Embed
  #  - thumbnail: String specifying the URL to the Image that should be used
  #
  ## Example
  #    make_embed("C++", "Made by competent Humans", "http://elixir-lang.org/images/logo/logo.png")
  def make_embed(title, contents, thumbnail, lang_color) do
    %Alchemy.Embed{}
    |> title(title)
    |> description(contents)
    |> image(thumbnail)
    |> color(lang_color)
  end

  @doc """
  Simple Helper Command to inform you about the faulty Execution of the learn Command.
  """
  #### learn/0
  ## Send an information message about how to correctly use the learn Command.
  Cogs.def learn() do
    error_embed("No Language specified. Type `!learn all` to view all available Languages.")
    |> Cogs.send
  end

  @doc """
  Displays Resources for the specified Language.

  ## Subcommands
    - `learn all`: Show all available languages with a small description.
    - `learn <lang>': Look up Resources for a Language.

  ## Examples
      # Display all available Languages
      !learn all

      # Display Resources for Python
      !learn python

      # Display Resources for Elixir
      !learn elixir
  """
  Cogs.def learn("all") do
    all_languages = [
      {
        "**c++**",
        "A low-level, fast, general-purpose, compiled programming language designed for building time-critical applications."
      },
      {
        "**elixir**",
        "A dynamic, functional, compiled language designed for building scalable and maintainable applications. Runs on the Erlang VM, known for low-latency, distributed and fault-tolerant systems."
      },
      {
        "**javascript**",
        "A lightwighted, interpreted or JIT-compiled programming language with first-class functions. It's a multi-paradigm, dynamic language, supporting object-oriented, imperative, and declarative styles."
      },
      {
        "**python**",
        "An easy to learn, general-purpose, interpreted programming language with efficient high-level data structures and a simple but effective approach to OOP."
      },
      {
        "**rust**",
        "A Functional/Procedural/Data oriented systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety."
      },
      {
        "**scala**",
        "Scala is a general-purpose programming language providing support for functional programming and a strong static type system. Designed to be concise, many of Scala's design decisions were designed to build from criticisms of Java."
      },
      {
        "**D-lang**",
        "D a systems programming language with C-like syntax and static typing. It combines efficiency, control and modeling power with safety and programmer productivity."
      }
    ]
    auto_field_embed("Available Learning Resources", all_languages)
    |> Cogs.send
  end
  Cogs.def learn("rust") do
    make_embed("Resources for Rust",
               "**- GENERAL -**
                • **The Book:tm:**: <https://doc.rust-lang.org/book/>
                • **Rust by Example**: <http://rustbyexample.com/>
                • **The __Rustonomicon__, a guide to writing unsafe Rust**: <https://doc.rust-lang.org/nomicon/>",
                "https://www.rust-lang.org/logos/rust-logo-128x128-blk.png", 0xCC6C12)
    |> Cogs.send
  end

  Cogs.def learn("scala") do
    make_embed("Resources for Scala", "
                **- GENERAL -**                
                • **Scala School**: <https://twitter.github.io/scala_school/>                
                • **Learn Scala in Y Minutes**: <https://learnxinyminutes.com/docs/scala/>                
                • **Programming Scala**: <http://ccfit.nsu.ru/~den/Scala/programming_in_scala_2nd.pdf>
                ","https://www.scala-lang.org/resources/img/smooth-spiral.png", 0xAD0819)
    |> Cogs.send
  end
  Cogs.def learn("D-lang") do
    make_embed("Resources for D-lang", "
                **- GENERAL -**
                • **D-lang Home Page**: <https://dlang.org/>
                • **D-lang Tour**: <https://tour.dlang.org/>",
                "https://dlang.org/images/compiler-dmd.png", 0xD60C02)
    |> Cogs.send
  end
  Cogs.def learn("c++") do
    make_embed("Resources for C++", "
                **- GENERAL -**
                • **C++ Resource Network**: <http://www.cplusplus.com>
                • **Standard C++ Library Reference**: <http://www.cplusplus.com/reference/>
                • **Standard C++**: <https://isocpp.org>
                
                **- LEARNING -**
                • **LearnCpp**: <http://www.learncpp.com>
                • **C++ Language**: <http://www.cplusplus.com/doc/tutorial/>
                • **Programming: Principles and Practice using C++**: <https://ebooks-it.org/0321992784-ebook.htm>

                **- POPULAR LIBRARIES -**
                • **Boost** (general-purpose): <http://www.boost.org>
                • **SDL2** (multimedia): <http://libsdl.org>
                • **OpenGL** (multimedia): <https://www.opengl.org>
                ", "https://github.com/jwkratz/cpp_logo/blob/master/cpp_logo_small.png?raw=true", 0x2630A5)
    |> Cogs.send
  end
  Cogs.def learn("elixir") do
    make_embed("Resources for Elixir", "
                **- GENERAL -**
                • **Official Website**: <http://elixir-lang.org>
                • **Official Docs**: <http://elixir-lang.org/docs.html>

                **- LEARNING -**
                • **Elixir School**: <https://elixirschool.com>
                • **Introduction to Elixir**: <http://elixir-lang.org/getting-started/introduction.html>
                • **Code School - Elixir**: <https://www.codeschool.com/courses/try-elixir?utm_source=elixir_learning&utm_medium=referral>
                • **Learn Elixir in Y Minutes**: <https://learnxinyminutes.com/docs/elixir/>
                • **Other Resources**: <http://elixir-lang.org/learning.html>

                **- POPULAR LIBRARIES -**
                • **Alchemy** (discord library): <https://github.com/cronokirby/alchemy>
                • **Phoenix** (web framework): <http://www.phoenixframework.org>
                • **awesome-elixir** (collection of libraries): <https://github.com/h4cc/awesome-elixir>

                **- OTHER -**
                • **Repository**: <https://github.com/elixir-lang/elixir>
                • **Style Guide**: <https://github.com/christopheradams/elixir_style_guide>
                ", "https://raw.githubusercontent.com/elixir-lang/elixir-lang.github.com/master/images/logo/logo.png", 0x370C56)
    |> Cogs.send
  end
  Cogs.def learn("js") do learn(message, "javascript") end
  Cogs.def learn("javascript") do
    make_embed("Resources for JavaScript", "
                **- GENERAL -**
                • **JavaScript | MDN**: <https://developer.mozilla.org/en/docs/Web/JavaScript>

                **- LEARNING -**
                • **W3Schools JS Tutorial**: <https://www.w3schools.com/Js/>
                • **JavaScript.com**: <https://www.javascript.com>
                • **MDN | First Steps**: <https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps>
                • **MDN | Detailed Guide**: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide>

                **- POPULAR LIBRARIES -**
                • **Express** (web framework): <http://expressjs.com>
                • **Electron** (desktop apps): <https://electron.atom.io>
                • **discord.js** (discord library): <https://github.com/hydrabolt/discord.js>

                **- OTHER -**
                • **Reference**: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference>
                • **Node.js** (JS runtime): <https://nodejs.org/en/>
                • **Data Structures**: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures>
                ", "http://ozekiphone.com/attachments/706/javascript_logo_without_title.png", 0xE2D434)
    |> Cogs.send
  end
  Cogs.def learn("python") do
    make_embed("Resources for Python", "
               **- GENERAL -**
               • **Official Website**: <https://www.python.org>
               • **Official Docs**: <https://docs.python.org/3/>

               **- LEARNING -**
               • **Oficial Tutorial**: <https://docs.python.org/3/tutorial/index.html>
               • **Interactive Python Tutorial**: <http://www.learnpython.org>
               • **Automate The Boring Stuff**: <http://automatetheboringstuff.com>
               • **A Byte of Python**: <https://python.swaroopch.com>
               • **Google's Python Class**: <https://developers.google.com/edu/python/>
               • **Learn Python in Y Minutes**: <https://learnxinyminutes.com/docs/python/>
               • **Other Resources**: <http://docs.python-guide.org/en/latest/intro/learning/>

               **- POPULAR LIBRARIES -**
               • **NumPy** (scientific computing): <https://github.com/numpy/numpy>
               • **Flask** (web development framework): <https://github.com/pallets/flask>
               • **Requests** (HTTP library): <http://www.python-requests.org/en/master/>
               • **pygame** (multimedia library): <http://www.pygame.org/news.html>
               • **discord.py** (discord library): <https://github.com/Rapptz/discord.py>

               **- OTHER -**
               • **Repository**: <https://github.com/python/cpython>
               • **Style Guide** (PEP8): <https://www.python.org/dev/peps/pep-0008/>
               ", "http://www.pngall.com/wp-content/uploads/2016/05/Python-Logo-PNG.png", 0x001C72)
    |> Cogs.send
  end
end
