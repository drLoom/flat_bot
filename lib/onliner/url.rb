# frozen_string_literal: true

module Onliner
  class Url
    attr_reader :url

    def initialize(url: nil)
      @url = url
    end

    def object_id
      url[/apartments\/(\d+)/, 1]
    end
  end
end
