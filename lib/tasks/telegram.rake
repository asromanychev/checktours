# frozen_string_literal: true

namespace :telegram do
  desc "Run Telegram bot (long-poll)"
  task bot: :environment do
    require "telegram/bot"

    token = ENV["TELEGRAM_BOT_TOKEN"]
    unless token && !token.empty?
      abort "TELEGRAM_BOT_TOKEN is not set. Put it into .env"
    end

    puts "[telegram] starting long-poll bot..."
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          chat_id = message.chat.id
          bot.api.send_message(chat_id: chat_id, text: "hello world")
        end
      end
    end
  end
end
