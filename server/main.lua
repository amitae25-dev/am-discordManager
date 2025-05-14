local DISCORD_API = Config.DiscordBot.discordAPI
local GUILD_ID = Config.DiscordBot.guildID
local BOT_TOKEN = "Bot " .. Config.DiscordBot.botToken
local cache = {}

if DISCORD_API ~= 'https://discord.com/api' then 
    print('^1[ERROR]:^7 Your discord API is changed!')
elseif GUILD_ID == 'YOUR_GUILD_ID' then 
    print('^1[ERROR]:^7 Please change your guild ID!')
elseif BOT_TOKEN == "Bot " or BOT_TOKEN == 'Bot YOUR_BOT_TOKEN' then 
    print('^1[ERROR]:^7 Please change your bot TOKEN!')
end

--- Function: Handles the http requests VIA discord                             Tested
local function DiscordRequest(method, endpoint, jsondata, reason)
    local promise = promise.new()
    PerformHttpRequest("https://discord.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
        promise:resolve({
            data = resultData,
            code = errorCode,
            headers = resultHeaders
        })
    end, method, jsondata and #jsondata > 0 and jsondata or "", {
        ["Content-Type"] = "application/json", 
        ["Authorization"] = BOT_TOKEN,
        ["X-Audit-Log-Reason"] = reason or "discordManager"
    })
    return Citizen.Await(promise)
end

--- Export: Get user info                                                       Tested
exports("GetUserInfo", function(discordId)
    if cache[discordId] and (GetGameTimer() - cache[discordId].time < 60000) then                                           -- Information placed in cache
        return cache[discordId].data
    end

    local res = DiscordRequest("GET", ("guilds/%s/members/%s"):format(GUILD_ID, discordId), nil)
    if not res or res.code ~= 200 then
        print(("[GetUserInfo] Error code: %s"):format(res and res.code or "nil"))
        return false
    end

    local parsed = json.decode(res.data)
    local user = parsed.user

    local avatarUrl = nil
    if user.avatar then
        local isGif = user.avatar:sub(1, 2) == "a_"
        avatarUrl = ("https://cdn.discordapp.com/avatars/%s/%s.%s"):format(                                                 -- Format the avatar
            user.id,
            user.avatar,
            isGif and "gif" or "png"
        )
    end

    local bannerUrl = nil
    if user.banner then
        local isGif = user.banner:sub(1, 2) == "a_"
        bannerUrl = ("https://cdn.discordapp.com/banners/%s/%s.%s"):format(                                                 -- Format the banner
            user.id,
            user.banner,
            isGif and "gif" or "png"
        )
    end

    local info = {
        id = user.id,
        username = user.username,
        discriminator = user.discriminator ~= "0" and user.discriminator or nil,
        global_name = user.global_name,
        nickname = parsed.nick or nil,
        joined_at = parsed.joined_at,
        roles = parsed.roles or {},
        avatar = avatarUrl,
        banner = bannerUrl,
        is_muted = parsed.mute,
        is_deaf = parsed.deaf
    }

    cache[discordId] = { data = info, time = GetGameTimer() }
    return info
end)

--- Export: Add role to user                                                    Tested
exports("AddRole", function(discordId, roleId)
    local res = DiscordRequest("PUT", ("/guilds/%s/members/%s/roles/%s"):format(GUILD_ID, discordId, roleId))
    return res.code == 204
end)

--- Export: Remove role from user                                               Tested
exports("RemoveRole", function(discordId, roleId)
    local res = DiscordRequest("DELETE", ("/guilds/%s/members/%s/roles/%s"):format(GUILD_ID, discordId, roleId))
    return res.code == 204
end)

--- Export: Check if user has a specific role                                   Tested
exports("HasRole", function(discordId, roleId)
    local user = exports["am-discordManager"]:GetUserInfo(discordId)
    if user and user.roles then
        for _, role in ipairs(user.roles) do
            if role == roleId then return true end
        end
    end
    return false
end)

--- Export: Check if user in the pre-configured guild                           Tested
exports("IsUserInGuild", function(discordId)
    local res = DiscordRequest("GET", ("guilds/%s/members/%s"):format(GUILD_ID ,discordId), nil)
    return res.code == 200
end)

--- Export: Send a DM to a specific user with a specific message                Tested
exports("SendDm", function(discordId, message)
    local createRes = DiscordRequest("POST", "/users/@me/channels", json.encode({ recipient_id = discordId }))
    if not createRes or createRes.code ~= 200 then return false end

    local dmData = json.decode(createRes.data)
    local channelId = dmData.id

    local msgRes = DiscordRequest("POST", ("/channels/%s/messages"):format(channelId), json.encode({ content = message }))
    return msgRes and msgRes.code == 200
end)

--- Export: Get guild name and member count                                     Tested
exports("GetGuildInfo", function()
    local res = DiscordRequest("GET", ("/guilds/%s?with_counts=true"):format(GUILD_ID))
    if res.code == 200 then
        local data = json.decode(res.data)
        return {
            name = data.name,
            member_count = data.approximate_member_count or data.member_count or 0,
            roles = data.roles and #data.roles or 0
        }
    end
    return false
end)
