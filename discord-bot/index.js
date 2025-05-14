const { Client, GatewayIntentBits } = require('discord.js');
require('dotenv').config();

const client = new Client({
    intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMembers],
});

client.once('ready', () => {
    console.log(`Started as ${client.user.tag}`);
});

client.login(process.env.BOT_TOKEN);