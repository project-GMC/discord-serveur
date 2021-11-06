#!/bin/sh
docker run -d --name bot -e DISCORD_TOKEN=${DISCORD_TOKEN} discord_bot_quotes:latest