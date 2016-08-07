module Pushover

    export PushoverClient, send

    using Requests: post, json


    _DEFAULT_TITLE = "default_title"
    _DEFAULT_PRIORITY = 0
    _DEFAULT_MAX_TITLE_LEN = 100
    _DEFAULT_MAX_MESSAGE_LEN = 512


    type PushoverException <: Exception
        response::Dict
    end

    type PushoverClient
        user_key::AbstractString
        api_token::AbstractString

        max_title_len::Int
        max_message_len::Int

        function PushoverClient(user_key, api_token;
                max_title_len=_DEFAULT_MAX_TITLE_LEN,
                max_message_len=_DEFAULT_MAX_MESSAGE_LEN)
            new(user_key, api_token, max_title_len, max_message_len)
        end
    end

    function _sanitize_priority(priority)
        if !in(priority, [-2, -1, 0, 1])
            priority = 0
        end
        priority
    end

    function _crop(msg, max_len)
        if max_len > 0 && length(msg) > max_len
            msg[1:max_len-3] * "..."
        else
            msg
        end
    end


    function send(client::PushoverClient, message::AbstractString;
                device=nothing, title=nothing, url=nothing, url_title=nothing,
                priority=nothing, timestamp=nothing, sound=nothing)

        base_url = "https://api.pushover.net"
        endpoint = "/1/messages.json"
        url_query = base_url * endpoint

        message = _crop(message, client.max_message_len)

        # Required parameters
        params = Dict{ASCIIString,Any}(
            "user" => client.user_key,
            "token" => client.api_token,
            "message" => message,
        )

        # Optional parameters
        if device != nothing
            params["device"] = device
        end

        if title != nothing
            params["title"] = _crop(title, client.max_title_len)
        end

        if url != nothing
            params["url"] = url
        end

        if url_title != nothing
            params["url_title"] = url_title
        end

        if priority != nothing
            params["priority"] = _sanitize_priority(priority)
        end

        if timestamp != nothing
            params["timestamp"] = timestamp
        end

        if sound != nothing
            params["sound"] = sound
        end

        println(params)

        raw_response = post(url_query; data = params)
        response = json(raw_response)

        if response["status"] != 1
            exception = PushoverException(response)
            throw(exception)
        end

    end

end # module
