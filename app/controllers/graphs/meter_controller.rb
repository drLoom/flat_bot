# frozen_string_literal: true

module Graphs
  class MeterController < ApplicationController
    def index
      @hists = FlatsHist.group(:date).average('price_usd / area').to_json
    end
  end
end
