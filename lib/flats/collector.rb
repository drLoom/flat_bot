# frozen_string_literal: true

require 'faraday'
require 'nokogiri'

module Flats
  class Collector
    def collect
      page_num = 1

      loop do
        response = Faraday.get(url(page_num))
        json = JSON.parse(response.body)

        results = json['apartments'].map { |r| parse(r) }
        save_results(results)

        Rails.logger.info "DONE #{page_num} / #{json['page']['last']}"
        break if json['page']['last'] == json['page']['current']

        page_num += 1
      end
    end

    def url(page_num)
      "https://r.onliner.by/pk/#bounds%5Blb%5D%5Blat%5D=53.7935409055208&bounds%5Blb%5D%5Blong%5D=27.38815696396424&bounds%5Brt%5D%5Blat%5D=54.018251789403934&bounds%5Brt%5D%5Blong%5D=27.779563729488906"
    end

    def parse(row)
      {
        date:      Date.current,
        object_id: row['id'],
        area:      row['area']['total'],
        price:     row['price']['converted']['BYN']['amount'],
        price_usd: row['price']['converted']['USD']['amount'],
        rooms:     row['number_of_rooms'],
        url:       row['url'],
        data:      row
      }
    end

    def save_results(results)
      results.each do |r|
        flat = ::FlatsHist.find_by(date: r[:date], object_id: r[:object_id]) || ::FlatsHist.new
        flat.update(r)
        flat.internal_id = flat.hash_internal_key
        flat.save
      end
    end
  end
end
