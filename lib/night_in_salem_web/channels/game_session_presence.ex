defmodule NightInSalemWeb.GameSessionPresence do
  use Phoenix.Presence, otp_app: :night_in_salem,
                        pubsub_server: NightInSalem.PubSub
end
