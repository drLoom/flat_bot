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

        user = extract_user(update)

        case cmd
        when '/stats'
          text = prepare_stats

          client.send_message(chat_id: user.chat_id, text: text, parse_mode: 'MarkdownV2')

        when '/settings'
          client.send_message(
            chat_id:      user.chat_id,
            text:         'Количество комнат',
            reply_markup: {
              inline_keyboard: [
                [
                  { text: '1', callback_data: 'settings_rooms_1' },
                  { text: '2', callback_data: 'settings_rooms_2' },
                  { text: '3', callback_data: 'settings_rooms_3' }
                ],
                [ 
                  { text: '4', callback_data: 'settings_rooms_4' },
                  { text: '5+', callback_data: 'settings_rooms_5+' }
                ]
              ]
            }
          )
        when /settings_rooms_\d/
          rooms = cmd[/\d+\+?/]
          # TODO: use 1 for now
          notification = user.notifications.first || user.notifications.create!(rooms: rooms)

          client.post('sendMessage', { chat_id: user.chat_id, text: notification.name })
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
      params = user_info(update['message'] || update['callback_query']['message'])
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
