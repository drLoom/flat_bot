# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot::Client do
  describe "Client yields message" do
    context "Mesage received" do
      let(:message) { create(:jmessage) }


      it "yields message" do
        allow(subject).to receive(:get_updates).and_yield(message)

        subject.get_updates do |m|
          expect(m).to eq(message)
        end
      end
    end
  end
end
