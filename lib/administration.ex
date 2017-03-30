defmodule HackBoat.Administration do
  @moduledoc """
  Provides Commands for administrating a Server.
  """

  use Alchemy.Cogs
  alias Alchemy.Cache
  alias Alchemy.Client

  # Get a Role from a Guild by its name
  defp role_by_name(guild_id, rolename) do
    {:ok, %Alchemy.Guild{roles: guild_roles}} = Cache.guild(guild_id)
    Enum.find(guild_roles, &(&1.name == rolename))
  end

  # Check if a User has the "Staff" Role by getting the Role ID
  defp is_staff(guild_id, member_id, staff_name \\ "Staff") do
    {:ok, %Alchemy.GuildMember{roles: member_roles}} = Cache.member(guild_id, member_id)
    staff_role = role_by_name(guild_id, staff_name)
    staff_role.id in member_roles
  end

  Cogs.def kick(_member) do
    guild_id = Cogs.guild_id()
    if is_staff(guild_id, message.author.id) do
      Enum.each(message.mentions, &Client.kick_member(guild_id, &1.id))
    end
  end
end
