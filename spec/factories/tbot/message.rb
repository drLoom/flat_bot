# frozen_string_literal: true

FactoryBot.define do
  factory :message, class: '' do
    skip_create

    # ignore do
    #   id { SecureRandom.random_number(1_000_000_000).to_s }
    #   name { "#{first_name} #{last_name}" }
    #   first_name "Joe"
    #   last_name "Bloggs"
    #   link { "http://www.facebook.com/#{username}" }
    #   username "jbloggs"
    #   location_id "123456789"
    #   location_name "Palo Alto, California"
    #   gender "male"
    #   email "joe@bloggs.com"
    #   timezone(-8)
    #   locale "en_US"
    #   verified true
    #   updated_time { SecureRandom.random_number(1.month).seconds.ago }
    #   token { SecureRandom.urlsafe_base64(100).delete("-_").first(100) }
    #   expires_at { SecureRandom.random_number(1.month).seconds.from_now }
    # end
  end
end
