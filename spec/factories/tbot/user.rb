# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'TelegramBot::Types::User' do
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
  end
end
