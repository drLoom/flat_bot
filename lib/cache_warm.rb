# frozen_string_literal: true

require 'faraday'

class CacheWarm
  def initialize
  end

  def call
    Rails.cache.clear
    host = Rails.application.config.host

    paths = %w[
      /graphs/charts
      /graphs/meter
      /graphs/meter/inc_dec
      /graphs/old_new
      /graphs/doubles
      /graphs/by_rooms/split
      /graphs/by_rooms
    ]

    paths.each do |path|
      url = "http://#{host}#{path}"

      touch_cache(url)
    end

    %w[/top_flats /top_newly].each do |path|
      %w[1 2 3 4 5].each do |rooms|
        url = "http://#{host}#{path}?rooms=#{rooms}"

        touch_cache(url)
      end
    end
  end

  private

  def touch_cache(url)
    puts url
    response = faraday.get(url)

    raise "#{url} failed" unless response.status == 200
  end

  def faraday
    @faraday ||= Faraday.new do |conn|
      conn.options.timeout = 300
    end
  end
end
