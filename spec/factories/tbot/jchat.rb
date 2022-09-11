# frozen_string_literal: true

FactoryBot.define do
  factory :jchat, class: Hash do
    skip_create

    sequence :id do |n|
      n
    end


    initialize_with { attributes.stringify_keys }
  end
end
