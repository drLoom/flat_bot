# frozen_string_literal: true

FactoryBot.define do
  factory :jmessage, class: Hash do
    skip_create

    sequence :message_id do |n|
      n
    end

    text { 'Test' }

    user { create(:juser) }
    chat { create(:jchat) }

    initialize_with { attributes.stringify_keys }
  end
end
