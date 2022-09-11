# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot::Reception do
  describe "#open" do
    subject { described_class.new(client: client) }
    let(:client) { double('TelegramBot::Client') }
    let(:chat)   { create(:jchat, id: t_user.chat_id) }
    let(:t_user) { create(:t_user, chat_id: 1) }
    let(:update) { create(:jupdate, message: message) }

    before do
      allow(client).to receive(:get_updates).and_yield(update)
    end

    context "stats" do
      let(:message) { create(:jmessage, text: '/stats', from: 'from', chat: chat) }

      before do
        [1, 2, 3, 4, 5].each do |i|
          create(:flats_hist, rooms: i)
          create(:flats_hist, rooms: i, date: Date.current)
        end
      end

      it 'prepare and send stats' do
        text = "*Total:* 5\n  *5\\+:* 1\n  *4:* 1\n  *3:* 1\n  *2:* 1\n  *1:* 1\n*Today:* 5\n  *5\\+:* 1\n  *4:* 1\n  *3:* 1\n  *2:* 1\n  *1:* 1\n"

        expect(client).to receive(:send_message).with(
          chat_id: t_user.chat_id, text: text, parse_mode: 'MarkdownV2'
        )

        subject.open
      end
    end
  end
end
