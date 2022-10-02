# frozen_string_literal: true

module Graphs
  class MeterController < ApplicationController
    def index
      @hists = Rails.cache.fetch("MeterController#hists", expires_in: 1.hours) do
        FlatsHist.group(:date).average('price_usd / area').to_json
      end
    end
  end
end
