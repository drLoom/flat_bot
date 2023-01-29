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

    def closed_flats
      @data = Rails.cache.fetch("MeterController#closed_flats", expires_in: 1.hours) do
        sql = <<~SQL
          select date, AVG(price_usd / area) meter_price, COUNT(id) as cnt
          from flats_hist fh JOIN (
              select object_id, max(date) as max_dt  from flats_hist group by object_id
          ) t on fh.object_id  = t.object_id and fh.date = t.max_dt
          where t.max_dt < (select date from flats_hist order by date desc limit 1)
          group by fh.date
        SQL

        ApplicationRecord.connection.execute(sql).to_a
      end

      respond_to do |format|
        format.json { render json: @data }
      end
    end
  end
end
