Config = {}

Config.DiscordBot = {
    discordAPI = 'https://discord.com/api',                                                             -- Leave it like this (if you change it it WILL break the script)
    guildID = 'YOUR_GUILD_ID',
    botToken = 'YOUR_BOT_TOKE',
    useRateLimiter = true                                                                               -- Needs to get tested, but it should work
}

--[[
                    Rate Limiter Config

    useRateLimiter = false          Your API can get timed out, only print error when no longer available the API

    useRateLimiter = true           Your API can't get timed out, if the API close to get timed out the requests gets into a queue

    useRateLimiter = "safe"         Your API can't get timed out, but the request not get queued

]]--