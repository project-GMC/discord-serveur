import discord 
import os
from dotenv import load_dotenv
import requests
import json
from keep_alive import keep_alive

load_dotenv()

DISCORD_TOKEN = os.getenv('DISCORD_TOKEN')


client = discord.Client()

def get_quote():
    response =requests.get("https://zenquotes.io/api/random")
    json_data= json.loads(response.text)
    quote= json_data[0]['q'] +" - "+json_data[0]['a']
    return quote

@client.event
async def on_ready():
    print("We have logged in as {0.user}".format(client))

@client.event
async def on_message(message):
    if message.author == client.user:
        return
    if message.content.startswith('$quote'):
        quote=get_quote()
        await message.channel.send(quote)

keep_alive()
client.run(DISCORD_TOKEN)
