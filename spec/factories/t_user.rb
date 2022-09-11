# frozen_string_literal: true

FactoryBot.define do
  factory :t_user, class: 'TUser' do
    sequence :tid do |n|
      n
    end

    first_name { 'Test First name' }
    username { 'Test Name' }
    is_bot { false }

    # t.string :language_code
    # t.bigint :chat_id
    # t.string :chat_type
  end
end
