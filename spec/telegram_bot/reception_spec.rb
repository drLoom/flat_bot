# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot::Reception do
  NOTIFICATIONS_TYPES = %w[n c].freeze

  describe "#open" do
    subject { described_class.new(client:) }
    let(:client) { double('TelegramBot::Client') }
    let(:chat)   { create(:jchat, id: t_user.chat_id) }
    let(:t_user) { create(:t_user, chat_id: 1) }
    let(:update) { create(:jupdate, message:) }

    before do
      allow(client).to receive(:get_updates).and_yield(update)
    end

    context "stats" do
      let(:message) { create(:jmessage, text: '/stats', from: 'from', chat:) }

      before do
        [1, 2, 3, 4, 5].each do |i|
          create(:flats_hist, rooms: i)
          create(:flats_hist, rooms: i, date: Date.current)
        end
      end

      it 'prepare and send stats' do
        text = "*Total:* 5\n  *5\\+:* 1\n  *4:* 1\n  *3:* 1\n  *2:* 1\n  *1:* 1\n*Today:* 5\n  *5\\+:* 1\n  *4:* 1\n  *3:* 1\n  *2:* 1\n  *1:* 1\n"

        expect(client).to receive(:send_message).with(
          chat_id: t_user.chat_id, text:, parse_mode: 'MarkdownV2'
        )

        subject.open
      end
    end

    context 'settings' do
      let(:message) { create(:jmessage, text: '/settings', from: 'from', chat:) }

      it 'show settings keybord' do
        markup = {
          inline_keyboard: [
            [{ text: "Новые объявления",callback_data: "settings_keyboard_n" },
             { text: "Изменение цены", callback_data: "settings_keyboard_c" }]],
          resize_keyboard: true
        }

        expect(client).to receive(:send_message).with(
          chat_id: t_user.chat_id, text: 'Настройте параметры поиска', reply_markup: markup
        )

        subject.open
      end
    end

    NOTIFICATIONS_TYPES.each do |type|
      context "room settings #{type}" do
        let(:message) do
          create(:jmessage,
                text: "/get_rooms_settings_#{type}",
                from: 'from',
                chat:)
        end
        let(:update_message) { create(:jmessage) }
        let(:update) { create(:jupdate, message:, callback_query: { 'message' => update_message }) }

        it 'show roowms settings keybord' do
          markup = {
            inline_keyboard:
                             [
                               [{ text: "1", callback_data: "settings_#{type}_rooms_1" },
                                { text: "2", callback_data: "settings_#{type}_rooms_2" },
                                { text: "3", callback_data: "settings_#{type}_rooms_3" }],
                              [{ text: "4", callback_data: "settings_#{type}_rooms_4" },
                               { text: "5+", callback_data: "settings_#{type}_rooms_5+" },
                               { text: "Любое", callback_data: "settings_#{type}_rooms_" },
                               { text: "Назад", callback_data: "back_from_#{type}" }]]
          }

          expect(client).to receive(:post).with(
            'editMessageText',
            message_id: update_message['message_id'],
            chat_id: t_user.chat_id, text: 'Количество комнат', reply_markup: markup
          )

          subject.open
        end
      end
    end

    NOTIFICATIONS_TYPES.each do |type|
      context 'area settings' do
        let(:message) do
          create(:jmessage,
                 text: "/get_area_settings_#{type}",
                 from: 'from',
                 chat:)
        end
        let(:update_message) { create(:jmessage) }
        let(:update) { create(:jupdate, message:, callback_query: { 'message' => update_message }) }

        it 'show area settings keybord' do
          markup = {
            inline_keyboard: [
              [{ text: "<= 30", callback_data: "settings_#{type}_area_l30" },
                { text: "30-50", callback_data: "settings_#{type}_area_30_50" },
                { text: "50-80", callback_data: "settings_#{type}_area_50_80" }],
              [{ text: "80-110", callback_data: "settings_#{type}_area_80_110" },
                { text: ">110", callback_data: "settings_#{type}_area_g110" },
                { text: "Любое", callback_data: "settings_#{type}_area_" },
                { text: "Назад", callback_data: "back_from_#{type}" }]
            ]
          }

          expect(client).to receive(:post).with(
            'editMessageText',
            message_id: update_message['message_id'],
            chat_id: t_user.chat_id, text: 'м²', reply_markup: markup
          )

          subject.open
        end
      end
    end

    NOTIFICATIONS_TYPES.each do |type|
      context 'price settings' do
        let(:message) do
          create(:jmessage,
                 text: "/get_price_settings_#{type}",
                 from: 'from',
                 chat:)
        end
        let(:update_message) { create(:jmessage) }
        let(:update) { create(:jupdate, message:, callback_query: { 'message' => update_message }) }

        it 'show area settings keybord' do
          markup = {
            inline_keyboard: [
              [{ text: "<= 30", callback_data: "settings_#{type}_price_l30" },
                { text: "30-70", callback_data: "settings_#{type}_price_30_70" },
                { text: "70-90", callback_data: "settings_#{type}_price_70_90" }],
              [{ text: "90-120", callback_data: "settings_#{type}_price_90_120" },
                { text: ">120", callback_data: "settings_#{type}_price_g120" },
                { text: "Любая", callback_data: "settings_#{type}_price_" },
                { text: "Назад", callback_data: "back_from_#{type}" }]
            ]
          }

          expect(client).to receive(:post).with(
            'editMessageText',
            message_id: update_message['message_id'],
            chat_id: t_user.chat_id, text: 'Цена', reply_markup: markup
          )

          subject.open
        end
      end
    end

    NOTIFICATIONS_TYPES.each do |type|
      context 'price direction settings' do
        let(:message) do
          create(:jmessage,
                 text: "/get_price_direction_settings_#{type}",
                 from: 'from',
                 chat:)
        end
        let(:update_message) { create(:jmessage) }
        let(:update) { create(:jupdate, message:, callback_query: { 'message' => update_message }) }

        it 'show area settings keybord' do
          markup = {
            inline_keyboard: [
              [{ text: "↑", callback_data: "settings_#{type}_dprice_+" },
               { text: "↓", callback_data: "settings_#{type}_dprice_-" },
               { text: "↑↓", callback_data: "settings_#{type}_dprice_=" }],
            ]
          }

          expect(client).to receive(:post).with(
            'editMessageText',
            message_id: update_message['message_id'],
            chat_id: t_user.chat_id, text: 'Направление цены', reply_markup: markup
          )

          subject.open
        end
      end
    end

    context 'settings_keyboard' do
      context 'price change' do
        let(:message) { create(:jmessage, text: 'settings_keyboard_c', from: 'from', chat:) }

        it 'show price change keybord' do
          markup = {
            inline_keyboard:
                             [[{ text: "Количество комнат", callback_data: "get_rooms_settings_c" }, { text: "м²", callback_data: "get_area_settings_c" }],
                             [{ text: "Цена", callback_data: "get_price_settings_c" }, { text: "Направление Цены", callback_data: "get_price_direction_settings_c" }]],
            resize_keyboard: true
          }
          expect(client).to receive(:send_message).with(
            chat_id: t_user.chat_id, text: 'Изменение цены', reply_markup: markup
          )

          subject.open
        end
      end

      context 'new offers' do
        let(:message) { create(:jmessage, text: 'settings_keyboard_n', from: 'from', chat:) }

        it 'show new offers keybord' do
          markup = {
            inline_keyboard: [
              [{ text: "Количество комнат", callback_data: "get_rooms_settings_n" }, { text: "м²", callback_data: "get_area_settings_n" }],
               [{ text: "Цена", callback_data: "get_price_settings_n" }]],
            resize_keyboard: true
          }

          expect(client).to receive(:send_message).with(
            chat_id: t_user.chat_id, text: 'Новые объвления', reply_markup: markup
          )

          subject.open
        end
      end
    end

    context 'set settings' do
      let(:juser) { create(:juser, chat_id: 1) }
      let(:t_user) { create(:t_user, tid: juser['id'], chat_id: 1) }

      context 'set rooms settings' do
        NOTIFICATIONS_TYPES.each do |type|
          context 'rooms setting' do
            let(:rooms) { '3' }
            let(:message) do
              create(:jmessage,
                     text: "settings_#{type}_rooms_#{rooms}",
                     from: juser,
                     user: juser,
                     chat:)
            end
            let(:update_message) { create(:jmessage) }
            let(:update) { create(:jupdate, message:, callback_query: { 'message' => update_message }) }


            it 'save rooms setting' do
              pds = if type != 'n'
                      { callback_data: "get_price_direction_settings_#{type}", text: "Направление Цены" }
                    else
                      {}
                    end

              markup = {
                inline_keyboard: [
                  [
                    { text: "Количество комнат", callback_data: "get_rooms_settings_#{type}" },
                    { text: "м²", callback_data: "get_area_settings_#{type}" }
                  ],
                  [
                    { callback_data: "get_price_settings_#{type}", text: "Цена" },
                    **pds
                  ]
                ],
                resize_keyboard: true
              }

              expect(client).to receive(:post).with(
                'editMessageText',
                message_id: update_message['message_id'],
                chat_id: t_user.chat_id, text: "Комнат #{rooms}", reply_markup: markup
              )

              subject.open

              expect(TUsserNotification.count).to eq(1)
              user_notification = t_user.notifications.first

              aggregate_failures 'user notification' do
                expect(user_notification.ntype).to eq(type)
                expect(user_notification.rooms).to eq(rooms)
              end
            end
          end
        end
      end
    end
  end
end
