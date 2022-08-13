# frozen_string_literal: true

module TelegramBot
  class Reception
    attr_reader :client

    def initialize
      @client =  Client.new(logger: Rails.logger)
    end

    def open
      client.get_updates do |update|

        cmd = if update['message']
          update['message']['text']
        elsif update['callback_query']
          update['callback_query']['data']
        end

        user = extract_user(update) if update['message']

        case cmd
        when '/stats'
          text = prepare_stats

          client.send_message(chat_id: user.chat_id, text: text, parse_mode: 'MarkdownV2')
        when 'test_inline'
          client.send_message(
            chat_id:      user.chat_id,
            text:         'Inline Keyboard',
            reply_markup: {
              inline_keyboard: [
                [
                  { text: 'inline A',   callback_data: 'inline_a_pressed' }
                ],
                [ 
                  { text: 'inline B',   callback_data: 'inline_b_pressed' }
                ]
              ]
            }
          )
        when 'inline_a_pressed'
          client.post(
            'answerCallbackQuery',
            {
              callback_query_id: update['callback_query']['id'],
              text:              'Answer',
              show_alert:        false
            }
          )
        else
          text = <<~MARK.squish
            _some_
          MARK
          client.send_message(chat_id: user.chat_id, text: text, parse_mode: 'MarkdownV2')
        end
      end
    end

    def extract_user(update)
      params = user_info(update['message'])
      TUser.find_by(params) || TUser.create!(params)
    end

    def user_info(update)
      { tid: update['from']['id'],  chat_id: update['chat']['id'] }
    end

    def prepare_stats
      <<~STATS
        *Total:* #{FlatsHist.last_collected}
          *5\\+:* #{FlatsHist.recent5}
          *4:* #{FlatsHist.recent4}
          *3:* #{FlatsHist.recent3}
          *2:* #{FlatsHist.recent2}
          *1:* #{FlatsHist.recent1}
        *Today:* #{FlatsHist.last_newly}
          *5\\+:* #{FlatsHist.newly5}
          *4:* #{FlatsHist.newly4}
          *3:* #{FlatsHist.newly3}
          *2:* #{FlatsHist.newly2}
          *1:* #{FlatsHist.newly1}
      STATS
    end
  end
end

# module TelegramBot
#   class PollingV
#     def start
#       Telegram::Bot::Client.run(Rails.application.credentials.real_e_m_bot[:token], logger: Rails.logger) do |bot|
#         bot.listen do |message|
#           puts 'poll'
#           case message.text
#           when '/start'
#             bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
#           when '/stats'
#             question = 'Статистика по:'
#             answers  = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
#               keyboard: [['Total']],
#               one_time_keyboard: true
#             )
#             bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
#           when 'Total'
#             text = "Collected: #{FlatsHist.last_collected}"
#             bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: answers)
#           when '/stop'
#             bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
#           else
#           end
#         end
#       end
#     end
#   end
# end
