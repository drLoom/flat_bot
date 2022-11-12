# frozen_string_literal: true

module Stats
  class MainPageController < ApplicationController
    def totals
      @totals = Rails.cache.fetch("MainPageController#totals", expires_in: 1.hours) do
        prev_date = prev_date = FlatsHist.distinct.select(:date).order(date: :desc).limit(1).offset(1).first.date
        last_collected = FlatsHist.last_collected
        percent = ((FlatsHist.where(date: prev_date).count(:object_id).to_f / last_collected) * 100 - 100).round(4)

        {
          total:   last_collected,
          percent: percent
        }
      end
    end
  end
end
