defmodule HackBoat do
  @moduledoc """
  The main application that runs the bot
  """
  use Application
  alias Alchemy.Client

  @token Application.fetch_env!(:hackBoat, :token)


  def start(_, _) do
    run = Client.start(@token, selfbot: "197177484792299522")
    use HackBoat.Elixir.Eval
    use HackBoat.Learn
    run
  end

end  # HackBoat
