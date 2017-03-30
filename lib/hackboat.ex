defmodule HackBoat do
  @moduledoc """
  The main application that runs the bot
  """
  use Application
  alias Alchemy.Client

  @token Application.fetch_env!(:hackBoat, :token)

  def start(_, _) do
    run = Client.start(@token)
    use HackBoat.Administration
    use HackBoat.Information
    use HackBoat.Roles
    run
  end

end
