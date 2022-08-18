# frozen_string_literal: true

module TelegramBot
  class Reception
    attr_reader :client

    def initialize
      @client =  Client.new(logger: Rails.logger)
      @anecs  = File.read('tmp/anecs.txt').split('SEPARATOR')
    end

    def open
      client.get_updates do |update|
        cmd  = extract_cmd(update)
        user = extract_user(update)

        case cmd
        when '/stats'
          client.send_message(chat_id: user.chat_id, text: prepare_stats, parse_mode: 'MarkdownV2')
        when '/settings', 'Настроить нотификации'
          client.send_message(chat_id: user.chat_id, text: 'Настройте параметры поиска', reply_markup: settings_keyboard)
        when 'get_rooms_settings'
          client.post(
            'editMessageText',
            chat_id: user.chat_id,
            message_id:   update['callback_query']['message']['message_id'],
             text: 'Количество комнат', reply_markup: rooms_keyboard
          )
        when 'get_area_settings'
          client.post(
            'editMessageText',
            message_id:   update['callback_query']['message']['message_id'],
            chat_id: user.chat_id, text: 'м²', reply_markup: area_keyboard
          )
        when 'get_price_settings'
          client.post(
            'editMessageText',
            message_id:   update['callback_query']['message']['message_id'],
            chat_id: user.chat_id, text: 'Цена', reply_markup: price_keyboard
          )
        when /settings_rooms_/
          rooms = cmd[/\d+\+?/]
          # TODO: use 1 for now
          notification = user.notifications.first || user.notifications.new
          notification.update!(rooms: rooms)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard
            )
        when /settings_area_/
          setting = cmd[/settings_area_(\w+)/, 1]
          notification = user.notifications.first || user.notifications.new
          notification.update!(meters: setting)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard
            )
        when /settings_price_/
          setting = cmd[/settings_price_(\w+)/, 1]
          notification = user.notifications.first || user.notifications.new
          notification.update!(price: setting)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard
            )
        when 'back_from_rooms', 'back_from_area', 'back_from_price'
          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             message_id:   update['callback_query']['message']['message_id'],
             text:         'Настройте параметры поиска',
             reply_markup: settings_keyboard,
          )
        when '/start'
          ans = client.post(
            'sendMessage',
            {
              chat_id:      user.chat_id,
              text:         'Привет!',
              reply_markup: {
                keyboard:        [
                  [ user.notifications&.first&.name || 'Настроить нотификации'] # TODO: n+1
                ],
                resize_keyboard: true
              }
            }
          )
        when /\/feedback/
          feedback = cmd[/\/feedback(.*)/, 1]&.strip
          next unless feedback.present?

          feedback = "Feedback from (#{user.id}): #{feedback}"
          client.send_message(chat_id: TUser.find(2).chat_id, text: feedback)
        else
          client.send_message(chat_id: user.chat_id, text: @anecs.sample)
        end
      end
    end

    def extract_cmd(update)
      if update['message']
        update['message']['text']
      elsif update['callback_query']
        update['callback_query']['data']
      end
    end

    def extract_user(update)
      params = user_info(update['message'] || update['callback_query']['message'])
      TUser.find_by(params) || TUser.create!(params)
    end

    def user_info(update)
      { tid: update['from']['id'],  chat_id: update['chat']['id'] }
    end

    def settings_keyboard
      {
        inline_keyboard: [
          [
            { text: 'Количество комнат', callback_data: 'get_rooms_settings' },
            { text: 'м²', callback_data: 'get_area_settings' },
          ],
          [
            { text: 'Цена', callback_data: 'get_price_settings' }
          ]
        ],
        resize_keyboard: true
      }
    end

    def rooms_keyboard
      {
        inline_keyboard: [
          [
            { text: '1', callback_data: 'settings_rooms_1' },
            { text: '2', callback_data: 'settings_rooms_2' },
            { text: '3', callback_data: 'settings_rooms_3' }
          ],
          [
            { text: '4', callback_data:  'settings_rooms_4' },
            { text: '5+', callback_data: 'settings_rooms_5+' },
            { text: 'Любое', callback_data: 'settings_rooms_' },
            { text: 'Назад', callback_data: 'back_from_rooms' }
          ]
        ]
      }
    end

    def area_keyboard
      {
        inline_keyboard: [
          [
            { text: '<= 30', callback_data: 'settings_area_l30' },
            { text: '30-50', callback_data: 'settings_area_30_50' },
            { text: '50-80', callback_data: 'settings_area_50_80' }
          ],
          [
            { text: '80-110', callback_data:  'settings_area_80_110' },
            { text: '>110', callback_data: 'settings_area_g110' },
            { text: 'Любое', callback_data: 'settings_area_' },
            { text: 'Назад', callback_data: 'back_from_area' }
          ]
        ]
      }
    end

    def price_keyboard
      {
        inline_keyboard: [
          [
            { text: '<= 30', callback_data: 'settings_price_l30' },
            { text: '30-70', callback_data: 'settings_price_30_70' },
            { text: '70-90', callback_data: 'settings_price_70_90' }
          ],
          [
            { text: '90-120', callback_data:  'settings_price_90_120' },
            { text: '>120', callback_data: 'settings_price_g120' },
            { text: 'Любая', callback_data: 'settings_price_' },
            { text: 'Назад', callback_data: 'back_from_price' }
          ]
        ]
      }
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
