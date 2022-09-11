
# frozen_string_literal: true

FactoryBot.define do
  factory :flats_hist, class: 'FlatsHist' do
    date { Date.parse('2022-08-01') }

    sequence :object_id do |n|
      n
    end

    area { 100 }
    price { 900 }
    price_usd { 9}
    rooms { 3 }
    url { "https://r.onliner.by/pk/apartments/#{object_id}" }
    data { {} }
  end
end
