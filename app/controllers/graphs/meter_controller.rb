# frozen_string_literal: true

module Graphs
  class MeterController < ApplicationController
    layout 'theme'

    def index
      @hists = Rails.cache.fetch("MeterController#hists", expires_in: 1.hours) do
        FlatsHist.group(:date)
                 .select('AVG(price_usd / area), COUNT(id), date')
                 .to_json
      end
    end
  end
end
