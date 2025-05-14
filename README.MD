## Discord Manager By Amitae

### Description:
**discordManager** is a lightweight server-side Lua module that allows FiveM scripts to interact with the Discord API directly. It supports actions like role management, user queries, direct messaging, and guild data retrieval — all without needing a separate Node.js bot process.

### Functions:
##### GetUserInfo
- Returns informations about a specific user
- Info passed:
-- Discord Id
- Returned values:
-- "id" - User discord ID
--  "joined_at" - Date when the user joined the guild
-- "is_muted" - True if the user is currently muted
-- "is_deaf" - True if the user is currently deaf
-- "roles" - Returns a table of the user role IDs
-- "banner" - Returns a link to the user's banner gif or png
-- "avatar" - Returns a link to the user's avatar gif or png
-- "username" - Returns the discord username of the user
-- "global_name" - Returns the global username of the user

#### AddRole
- Add a specific role to a user
- Info passed:
-- Discord Id
-- Role Id
- Returned value:
-- Boolean if succeed

#### RemoveRole
- Remove a specific role from a user
- Info passed:
-- Discord Id
-- Role Id
- Returned value:
-- Boolean if succeed

#### HasRole
- Return the value if the player has a specific role
- Info passed:
-- Discord Id
-- Role Id
- Returned value:
-- Boolean if succeed

#### IsUserInGuild
- Return the value if the player is in the guild
- Info passed:
-- Discord Id
- Returned value:
-- Boolean if true or false

#### SendDm
- Return the value if the it was successful or not
- Info passed:
-- Discord Id
-- Message
- Returned value:
-- Boolean if succeed

#### GetGuildInfo
- Return information about your guild
- Info passed:
-- None
- Returned value:
-- "name" - Guild name
-- "member_count" - Guild member count
-- "roles" - Role IDs

### Usage:
```lua
exports["am-discordManager"]:GetUserInfo(discordId --[[string without the "discord"]])
	returns table
	{"id": "string", "joined_at": "string", "is_muted": "boolean", "is_deaf": "boolean", "roles": "table", "banner": "string", "global_name": "string", "avatar": "string", "username": "string"}

exports["am-discordManager"]:AddRole(discordId --[[string without the "discord"]], roleId --[[intiger]])
	returns boolean

exports["am-discordManager"]:RemoveRole(discordId --[[string without the "discord"]], roleId --[[intiger]])
	returns boolean

exports["am-discordManager"]:HasRole(discordId --[[string without the "discord"]], roleId --[[intiger]])
	returns boolean

exports["am-discordManager"]:IsUserInGuild(discordId --[[string without the "discord"]], roleId --[[intiger]])
	returns boolean

exports["am-discordManager"]:SendDm(discordId --[[string without the "discord"]], message --[[string]])
	returns boolean

exports["am-discordManager"]:GetGuildInfo()
	returns table
	{"name": "string", "member_count": "intiger OR unknown", "roles": "intiger"}
```

### Setup:
#### Create a Bot on Discord:
- Go to Discord [Developer Portal](https://discord.com/developers/applications "Developer Portal")
- Create a new application → Go to "Bot" → Click "Add Bot"
- Enable Server Members Intent
- **Copy the bot token **— you will need this
- **Invite the bot to your server**

#### Run the discord bot:
- Go to `am-discordManager\discord-bot`
- Open up the `.env` file
- **Paste your discord bot token**
- Open CMD and browse to `am-discordManager\discord-bot`
- After you found the folder paste the following commands:
-- `npm init -y`
-- `npm install discord.js dotenv`
-- `node index.js`
- After you ran the commands wait a little bit
- **Now your discord bot is running**

#### Configure the script:
- Open the `config.lua` file
- Paste your guildID and botToken 
- How to get your guild ID? 
-- Make sure you are in [developer mode](https://www.howtogeek.com/714348/how-to-enable-or-disable-developer-mode-on-discord/ "developer mode") in discord 
-- Right mouse button on your guild (discord server) and press `Copy ID`
-- **Now you have the guild ID**

### Warning:
- **You must pass the formated discord ID to the script**

```lua
local id = GetPlayerIdentifierByType(source, "discord")
id = id and id:gsub("discord:", "")

```

- **Discord bot must run all the time during use**

### Version:
- 1.0.0

### Author:
- Discord: Amitae_
- Discord Server (support): [asd.asd Scripts](https://discord.gg/cgQMXEBDuR "asd.asd Scripts")
