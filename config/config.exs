# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :hackBoat,
  # Put either your Bot Token or your Local Storage Token (for Selfbots) here.
  token: "",

  # Put User IDs that can use Evaluation Commands without restriction here.
  authorized: [""],

  # Add your User ID here if you want to use the Bot as a Selfbot. Leave empty if this is not the case.
  self_id: ""
