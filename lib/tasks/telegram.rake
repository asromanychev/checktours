# frozen_string_literal: true

namespace :telegram do
  desc "Run Telegram bot (long-poll)"
  task bot: :environment do
    require "telegram/bot"

    token = ENV["TELEGRAM_BOT_TOKEN"]
    unless token && !token.empty?
      abort "TELEGRAM_BOT_TOKEN is not set. Put it into .env"
    end

    # Flush logs immediately
    STDOUT.sync = true
    $stdout.sync = true
    $stderr.sync = true
    puts "[telegram] starting long-poll bot..."
    Telegram::Bot::Client.run(token) do |bot|
      begin
        puts "[telegram] deleting webhook (if any)..."
        bot.api.delete_webhook(drop_pending_updates: true)
      rescue => e
        puts "[telegram] delete_webhook failed: #{e.class}: #{e.message}"
      end

      # Verify token/connectivity
      begin
        me = bot.api.get_me
        user = me && me["result"]
        username = user && user["username"]
        id = user && user["id"]
        puts "[telegram] bot connected as @#{username} (id=#{id})"
      rescue => e
        puts "[telegram] get_me failed: #{e.class}: #{e.message}"
      end

      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          chat_id = message.chat.id
          text = message.respond_to?(:text) ? message.text : nil
          puts "[telegram] received message from #{chat_id}: #{text.inspect}"
          bot.api.send_message(chat_id: chat_id, text: "hello world")
        end
      end
    end
  end
end
