defmodule HackBoat.Roles do
  @moduledoc """
  Contains Commands for self-assigning and removing Roles.
  """

  use Application
  use Alchemy.Cogs
  alias Alchemy.Client

  # The Self-Assignable Roles set in the Configuration
  @self_assignable Application.fetch_env!(:hackBoat, :roles)

  # Get a Role
  defp get_role(guild, rolename) do
    case Enum.filter(guild.roles, &(&1.name == rolename)) do
      [] -> nil
      [wanted_role | _] -> wanted_role
    end
  end

  @doc """
  View all self-assignable Roles that are specified in config.exs.
  """
  Cogs.def roles do
    "**- Self-assignable Roles** -\n" <> Enum.map_join(@self_assignable, ", ", &(&1))
    |> Cogs.say
  end

  @doc """
  Helper Command to inform the User about wrong usage of the Command.                                                                                                                 "WRONG"
  """
  Cogs.def joinrole do
    Cogs.say "You need to specify the Role which you want to join. "
          <> "List all using `!roles`"
  end

  @doc """
  Join a Role.
  Takes the Rolename as an argument and searches the guild for the given
  rolename. Afterwards, it checks whether the Role is self-assignable.
  """
  Cogs.def joinrole(rolename) do
    {:ok, guild} = Cogs.guild()
    {:ok, member} = Cogs.member()
    wanted_role = get_role(guild, rolename)
    cond do
      !wanted_role ->
        "This Guild does not have any Role named **#{rolename}**."
      wanted_role.id in member.roles ->
        "You already have this Role assigned."
      !(wanted_role.name in @self_assignable) ->
        "The Role **#{wanted_role.name}** is **not self-assignable**."
      true ->
        case Task.await Client.add_role(guild.id, member.user.id, wanted_role.id) do
          {:ok, nil} -> "Gave you the **#{wanted_role.name}** Role."
          {:error, term} -> "**Cannot add the Role**: #{term.message} (#{term.code})."
        end
    end
    |> Cogs.say
  end

  @doc """
  Another helper Command to inform the User about wrong usage of the Command.                                                                                                                 "WRONG"
  """
  Cogs.def leaverole do
    Cogs.say "You need to specify the Role which you want to leave. "
          <> "List all using `!roles`"
  end

  @doc """
  Leave a Role.
  Takes the Rolename as an argument and like joinrole, searches the guild for the
  given rolename. Afterwards, it's checked whether the Member already has
  the Role assigned andwhether it's self-assignable. And finally, it works.
  """
  Cogs.def leaverole(rolename) do
    {:ok, guild} = Cogs.guild()
    {:ok, member} = Cogs.member()
    wanted_role = get_role(guild, rolename)
    cond do
      !wanted_role ->
        "This Guild does not have any Role named **#{rolename}**."
      !(wanted_role.id in member.roles) ->
        "You do not have this Role assigned."
      !(wanted_role.name in @self_assignable) ->
        "The role **#{wanted_role.name}** is **not self-assignable**."
      true ->
        case Task.await Client.remove_role(guild.id, member.user.id, wanted_role.id) do
          {:ok, nil} -> "Removed the **#{wanted_role.name}** Role from you."
          {:error, term} -> "**Cannot add the Role**: #{term.message} (#{term.code})."
        end
    end
    |> Cogs.say
  end


end
