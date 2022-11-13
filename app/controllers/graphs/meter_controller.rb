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

      respond_to do |format|
         format.json { render json: @hists }
       end
    end

    def inc_dec
      @data = Rails.cache.fetch("MeterController#inc_dec", expires_in: 1.hours) do
        Repositories::Flats::IncDec.new.call
      end

      respond_to do |format|
         format.json { render json: @data }
       end
    end
  end
end
