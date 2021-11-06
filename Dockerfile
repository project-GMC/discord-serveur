FROM discord_bot_quotes_base:latest

COPY . .

CMD [ "python3", "bot.py" ]