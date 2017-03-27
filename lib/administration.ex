defmodule HackBoat.Administration do
  @moduledoc """
  Contains Administration Commands that work with checking the
  Permissions of the top role of the User invoking the Command.
  """
  use Alchemy.Cogs
  alias Alchemy.Client
  alias Alchemy.Cache

  # Check if the given Member has the specified Role
  defp has_role(guild_id, member_id, rolename) do
    Enum.any?(Cache.member(guild_id, member_id).roles, &(&1.name == rolename))
  end

  # Get a Role
  defp get_role(guild, rolename) do
    case Enum.filter(guild.roles, &(&1.name == rolename)) do
      [] -> nil
      [wanted_role | _] -> wanted_role
    end
  end

  Cogs.def joinrole do
    Cogs.say "You need to specify the Role which you want to join. "
          <> "List all using `!roles`"
  end
  Cogs.def joinrole(rolename) do
    {:ok, guild} = Cogs.guild()
    wanted_role = get_role(guild, rolename)
    has_wanted_role = has_role(Cogs.guild().id, message.author.id, wanted_role)
    cond do
      !wanted_role ->
        Cogs.say "This Guild does not have any Role named **#{wanted_role}**."
      has_wanted_role ->
        Cogs.say "You already have this Role assigned."
      true ->
        Client.add_role(Cogs.guild().id, message.author.id, wanted_role.id)
        Cogs.say "Gave you the **#{wanted_role.name}** Role."
    end
  end
end
