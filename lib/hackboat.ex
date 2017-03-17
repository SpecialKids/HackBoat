defmodule HackBoat do
  @moduledoc """
  The main application that runs the bot
  """
  use Application
  alias Alchemy.Client

  @token Application.fetch_env!(:hackboat, :token)


  defmodule Commands do
  @moduledoc """
  A basic set of commands.
  """
  use Alchemy.Cogs

  Cogs.def ping, do: Cogs.say("pong")

  end


  def start(_, _) do
    run = Client.start(@token)
    use Commands
    run
  end

end
