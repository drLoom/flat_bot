# frozen_string_literal: true

module TelegramBot
  class Reception
    include ActionView::Helpers::NumberHelper

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

          client.send_message(chat_id: user.chat_id, text: 'Настройте параметры поиска', reply_markup: notifications_keyboard)
        when /settings_keyboard_\w/
          type = cmd[/settings_keyboard_(\w)/, 1]
          next unless %w[n c].include?(type)

          message = case type
          when 'c'
            'Изменение цены'
          when 'n'
            'Новые объвления'
          end

          client.send_message(chat_id: user.chat_id, text: message, reply_markup: settings_keyboard(type))
        when /get_rooms_settings/
          type = extract_type(cmd)

          client.post(
            'editMessageText',
            chat_id: user.chat_id,
            message_id: update['callback_query']['message']['message_id'],
            text: 'Количество комнат', reply_markup: rooms_keyboard(type)
          )
        when /get_area_settings/
          type = extract_type(cmd)

          client.post(
            'editMessageText',
            message_id:   update['callback_query']['message']['message_id'],
            chat_id: user.chat_id, text: 'м²', reply_markup: area_keyboard(type)
          )
        when /get_price_settings/
          type = extract_type(cmd)

          client.post(
            'editMessageText',
            message_id:   update['callback_query']['message']['message_id'],
            chat_id: user.chat_id, text: 'Цена', reply_markup: price_keyboard(type)
          )
        when /get_price_direction_settings/
          type = extract_type(cmd)

          client.post(
            'editMessageText',
            message_id:   update['callback_query']['message']['message_id'],
            chat_id: user.chat_id, text: 'Направление цены', reply_markup: price_direction_keyboard(type)
          )
        when /settings_\w_rooms_/
          type = extract_attr_settings(cmd)
          rooms = cmd[/\d+\+?/]
          # TODO: use 1 for now
          notification = user.notifications.find_by(ntype: type) || user.notifications.new(ntype: type)
          notification.update!(rooms: rooms)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard(type)
          )
        when /settings_\w_area_/
          type = extract_attr_settings(cmd)
          setting = cmd[/settings_\w_area_(\w+)/, 1]
          notification = user.notifications.find_by(ntype: type) || user.notifications.new(ntype: type)
          notification.update!(meters: setting)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard(type)
            )
        when /settings_\w_price_/
          type = extract_attr_settings(cmd)
          setting = cmd[/settings_\w_price_(\w+)/, 1]
          notification = user.notifications.find_by(ntype: type) || user.notifications.new(ntype: type)
          notification.update!(price: setting)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard(type)
            )
        when /settings_\w_dprice_.?/
          type = extract_attr_settings(cmd)
          direction = cmd[/.?\z/]
          notification = user.notifications.find_by(ntype: type) || user.notifications.new(ntype: type)
          notification.update!(price_direction: direction)

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             text:         notification.name,
             message_id:   update['callback_query']['message']['message_id'],
             reply_markup: settings_keyboard(type)
          )
        when /back_from_\w/
          type = cmd[/back_from_(\w)/, 1]
          message = case type
                    when 'c'
                      'Изменение цены'
                    when 'n'
                      'Новые объвления'
                    end

          client.post(
            'editMessageText',
             chat_id:      user.chat_id,
             message_id:   update['callback_query']['message']['message_id'],
             text:         message,
             reply_markup: settings_keyboard(type),
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
        when /onliner\.by.*apartments\/(\d+)/
          object_id = cmd[/onliner\.by.*apartments\/(\d+)/, 1].to_i
          history   = flatt_history(object_id)

          client.send_message(chat_id: user.chat_id, text: prepare_history(history))
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

    def notifications_keyboard
      {
        inline_keyboard: [
          [
            { text: 'Новые объявления', callback_data: 'settings_keyboard_n' },
            { text: 'Изменение цены', callback_data: 'settings_keyboard_c' },
          ]
        ],
        resize_keyboard: true
      }
    end

    def settings_keyboard(notification_type)
      keyboard = {
        inline_keyboard: [
          [
            { text: 'Количество комнат', callback_data: "get_rooms_settings_#{notification_type}" },
            { text: 'м²', callback_data: "get_area_settings_#{notification_type}" },
          ],
          [
            { text: 'Цена', callback_data: "get_price_settings_#{notification_type}" },
          ]
        ],
        resize_keyboard: true
      }

      if notification_type == 'c'
        keyboard[:inline_keyboard][1] << { text: 'Направление Цены', callback_data: "get_price_direction_settings_#{notification_type}" }
      end

      keyboard
    end

    def rooms_keyboard(type)
      {
        inline_keyboard: [
          [
            { text: '1', callback_data: "settings_#{type}_rooms_1" },
            { text: '2', callback_data: "settings_#{type}_rooms_2" },
            { text: '3', callback_data: "settings_#{type}_rooms_3" }
          ],
          [
            { text: '4', callback_data:  "settings_#{type}_rooms_4" },
            { text: '5+', callback_data: "settings_#{type}_rooms_5+" },
            { text: 'Любое', callback_data: "settings_#{type}_rooms_" },
            { text: 'Назад', callback_data: "back_from_#{type}" }
          ]
        ]
      }
    end

    def area_keyboard(type)
      {
        inline_keyboard: [
          [
            { text: '<= 30', callback_data: "settings_#{type}_area_l30" },
            { text: '30-50', callback_data: "settings_#{type}_area_30_50" },
            { text: '50-80', callback_data: "settings_#{type}_area_50_80" }
          ],
          [
            { text: '80-110', callback_data: "settings_#{type}_area_80_110" },
            { text: '>110', callback_data: "settings_#{type}_area_g110" },
            { text: 'Любое', callback_data: "settings_#{type}_area_" },
            { text: 'Назад', callback_data: "back_from_#{type}" }
          ]
        ]
      }
    end

    def price_keyboard(type)
      {
        inline_keyboard: [
          [
            { text: '<= 30', callback_data: "settings_#{type}_price_l30" },
            { text: '30-70', callback_data: "settings_#{type}_price_30_70" },
            { text: '70-90', callback_data: "settings_#{type}_price_70_90" }
          ],
          [
            { text: '90-120', callback_data:  "settings_#{type}_price_90_120" },
            { text: '>120', callback_data: "settings_#{type}_price_g120" },
            { text: 'Любая', callback_data: "settings_#{type}_price_" },
            { text: 'Назад', callback_data: "back_from_#{type}" }
          ]
        ]
      }
    end

    def price_direction_keyboard(type)
      {
        inline_keyboard: [
          [
            { text: '↑', callback_data: "settings_#{type}_dprice_+" },
            { text: '↓', callback_data: "settings_#{type}_dprice_-" },
            { text: '↑↓', callback_data: "settings_#{type}_dprice_=" }
          ],
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

    def flatt_history(object_id)
      binds = [ActiveRecord::Relation::QueryAttribute.new('object_id', object_id, ActiveRecord::Type::Integer.new)]
      results = ActiveRecord::Base.connection.exec_query(<<~SQL, 'sql', binds)
        select *
        from
        (
          select
            date,
            object_id,
            price_usd,
            lag(price_usd, 1) over (
              partition by object_id
              order by date
            ) previous_price
          from flats_hist
          where object_id = $1
          order by date
        ) t
        where previous_price <> price_usd or previous_price is null
      SQL

      results
    end

    def prepare_history(rows)
      rows.last(20).map do |r|
        [
          r['date'],
          number_to_currency(r['price_usd'], precision: 0, delimiter: ' '),
          direction(r['price_usd'], r['previous_price'])
        ].compact.join(' ')
      end.join("\n")
    end

    def direction(price, previous_price)
      return if price.blank? || previous_price.blank? || price == previous_price

      if price > previous_price
        '↑'
      else
        '↓'
      end
    end

    def extract_type(cmd)
      cmd[/(\w)\z/, 1]
    end

    def extract_attr_settings(cmd)
      cmd[/settings_(\w)_/, 1]
    end
  end
end
