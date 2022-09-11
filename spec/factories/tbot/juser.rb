# frozen_string_literal: true

FactoryBot.define do
  factory :juser, class: Hash do
    skip_create

    sequence :id do |n|
      n
    end

    is_bot { false }
    first_name { 'Test first name' }
    last_name { 'Test lastname' }
    username { 'Test name' }
    language_code { 'en' }
    is_premium { false }
    added_to_attachment_menu { false }
    can_join_groups { true }
    can_read_all_group_messages { true }
    supports_inline_queries { true }

    initialize_with { attributes.stringify_keys }

    #user { create(:user) }
    # ignore do
    #   id { SecureRandom.random_number(1_000_000_000).to_s }
    # end
  end
end
