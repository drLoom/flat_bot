# frozen_string_literal: true

require 'rails_helper'
#require 'telegram_bot/client'

RSpec.describe TelegramBot::Client do
  let(:client) { described_class.new }

  describe "Client yields message" do
    context "Mesage received" do
      let(:message) { create(:message) }


      it "yields message" do
        allow(client).to receive(:get_updates).and_yield(message)

        client.get_updates do |m|
          expect(m).to eq(message)
        end
      end
    end
  end
end
