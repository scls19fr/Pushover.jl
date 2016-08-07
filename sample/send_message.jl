using Pushover: PushoverClient, send

include("config.jl")

client = PushoverClient(CONFIG["USER_KEY"], CONFIG["API_TOKEN"])
message = "My first message"
send(client, message, priority=1)
