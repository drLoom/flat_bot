# frozen_string_literal: true

require 'telegram/bot'

module TelegramBot
  class PollingV
    def start
      Telegram::Bot::Client.run(Rails.application.credentials.real_e_m_bot[:token], logger: Rails.logger) do |bot|
        bot.listen do |message|
          puts 'poll'
          case message.text
          when '/start'
            bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
          when '/stats'
            question = 'Статистика по:'
            answers  = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
              keyboard: [['Total']],
              one_time_keyboard: true
            )
            bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
          when 'Total'
            text = "Collected: #{FlatsHist.last_collected}"
            bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: answers)
          when '/stop'
            bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
          else
          end
        end
      end
    end
  end
end
