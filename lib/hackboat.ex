defmodule HackBoat do
  @moduledoc """
  The main application that runs the bot
  """
  use Application
  alias Alchemy.Client

  @token Application.fetch_env!(:hackboat, :token)


  def start(_, _) do
    run = Client.start(@token)
    use HackBoat.Elixir.Eval
    run
  end

end  # HackBoat
