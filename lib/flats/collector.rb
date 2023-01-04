# frozen_string_literal: true

require 'faraday'
require 'nokogiri'

module Flats
  class Collector
    def collect
      urls.each do |link|
        page_num = 1

        loop do
          response = Faraday.get(url(link, page_num))
          json = JSON.parse(response.body)

          results = json['apartments'].map { |r| parse(r) }
          save_results(results)

          Rails.logger.info "DONE #{page_num} / #{json['page']['last']}"
          break if json['page']['last'] == json['page']['current']

          page_num += 1
          puts page_num
        end
      end
    end

    def url(link, page_num)
      link.sub('page_num', page_num.to_s)
    end

    def urls
      [
        "https://r.onliner.by/sdapi/pk.api/search/apartments?bounds%5Blb%5D%5Blat%5D=53.7554973999277&bounds%5Blb%5D%5Blong%5D=27.426064222141026&bounds%5Brt%5D%5Blat%5D=54.04034713456713&bounds%5Brt%5D%5Blong%5D=27.698222954691232&page=page_num&v=0.6375370292616709",
        "https://r.onliner.by/sdapi/pk.api/search/apartments?bounds%5Blb%5D%5Blat%5D=53.88298458332238&bounds%5Blb%5D%5Blong%5D=27.358935203978554&bounds%5Brt%5D%5Blat%5D=53.92896889700679&bounds%5Brt%5D%5Blong%5D=27.80854351167143&page=page_num&v=0.5423097444380389"
      ]
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
