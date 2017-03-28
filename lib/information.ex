defmodule HackBoat.Information do
  @moduledoc """
  Contains several Commands to get various information about the Guild, the
  User, the Message, the Bot, and other things.
  """

  use Alchemy.Cogs
  alias Alchemy.Channel
  alias Alchemy.Client
  alias Alchemy.User


  @doc """
  Provides information about the Guild this Command was used on.
  """
  Cogs.def serverinfo do
      {:ok, guild} = Cogs.guild()
      "**Name**: #{guild.name}\n"
      <> "**ID**: #{guild.id}\n"
      <> "**Region**: #{guild.region}\n"
      <> "**Members**: #{guild.member_count}\n"
      <> "**Owner**: #{guild.owner}\n"
      <> "**Created**: #{guild.joined_at}\n"
      <> "**Icon**: https://cdn.discordapp.com/icons/#{guild.id}/#{guild.icon}.jpg\n"
      <> "**Emojis**: #{Enum.map_join(guild.emojis, ", ", &("<:" <> &1.name <> ":" <> &1.id <> ">"))}"
      |> Cogs.say
  end

  @doc """
  Provides information about the Channel in which the Command was invoked.
  Only works on Guild Channels, because DM's do not have positions nor topics,
  nor guild IDs. They have a set number of recipients though.
  """
  Cogs.def channelinfo do
    {:ok, channel} = Task.await Client.get_channel(message.channel_id)
    "**ID**: #{channel.id}\n"
    <> "**Position**: #{channel.position}\n"
    <> "**Topic**: #{channel.topic}\n"
    <> "**Guild ID**: #{channel.guild_id}\n"
    |> Cogs.say
  end

  @doc """
  Provides information about the Member that invoked the Command.
  """
  Cogs.def userinfo do
    {:ok, member} = Cogs.member()
    "**Name**: #{member.user.username}##{member.user.discriminator}\n"
    <> "**ID**: #{member.user.id}\n"
    <> "**Avatar**: #{User.avatar_url(member.user)}"
    |> Cogs.say
  end

  @doc """
  Provides information about a mentioned User.
  """
  Cogs.def userinfo(_mention) do
    [wanted_user | _others] = message.mentions
    "**Name**: #{wanted_user.username}##{wanted_user.discriminator}\n"
    <> "**ID**: #{wanted_user.id}\n"
    <> "**Avatar**: #{User.avatar_url(wanted_user)}"
    |> Cogs.say
  end

  @doc """
  Gets the Avatar URL of the User that invoked the Command.
  """
  Cogs.def avatar do
    {:ok, member} = Cogs.member()
    "**Your Avatar URL**: #{User.avatar_url(member.user, "png", 512)}"
    |> Cogs.say
  end

  @doc """
  Gets the Avatar URL of a mentioned User.
  """
  Cogs.def avatar(_mention) do
    [wanted_user | _others] = message.mentions
    "**#{wanted_user.username}'s Avatar URL**: #{User.avatar_url(wanted_user, "png", 512)}"
    |> Cogs.say
  end
end
