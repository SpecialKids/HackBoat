defmodule HackBoat do
  @moduledoc """
  The main application that runs the bot
  """
  use Application
  alias Alchemy.Client

  @token Application.fetch_env!(:hackBoat, :token)
  @self_id Application.fetch_env!(:hackBoat, :self_id)
  
  def start(_, _) do
    run =
      if @self_id == "" do
        Client.start(@token)
      else
        Client.start(@token, selfbot: @self_id)
      end

    use HackBoat.Elixir.Eval
    use HackBoat.Learn
    run
  end

end  # HackBoat
