# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot::Reception do
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
            [{ text:          "Новые объявления",
               callback_data: "settings_keyboard_n" },
                { text: "Изменение цены", callback_data: "settings_keyboard_c" }]],
          resize_keyboard: true
        }

        expect(client).to receive(:send_message).with(
          chat_id: t_user.chat_id, text: 'Настройте параметры поиска', reply_markup: markup
        )

        subject.open
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
  end
end
