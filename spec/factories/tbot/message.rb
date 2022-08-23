# frozen_string_literal: true

FactoryBot.define do
  factory :message, class: 'TelegramBot::Types::Message' do
    skip_create

    sequence :message_id do |n|
      n
    end

    text { 'Test' }

    # ignore do
    #   id { SecureRandom.random_number(1_000_000_000).to_s }
    # end
  end
end
