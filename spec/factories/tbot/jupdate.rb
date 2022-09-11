# frozen_string_literal: true

FactoryBot.define do
  factory :jupdate, class: Hash do
    skip_create

    sequence :update_id do |n|
      n
    end

    message { create(:jmessage) }
    chat { create(:jchat) }

    initialize_with { attributes.stringify_keys }

    user { create(:juser) }
  end
end
