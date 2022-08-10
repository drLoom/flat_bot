# frozen_string_literal: true

class FlatsHist < ApplicationRecord
  self.table_name = 'flats_hist'

  class << self
    def last_date
      Rails.cache.fetch("FlatsHist#last_date", expires_in: 1.hours) { maximum(:date) }
    end

    def last_collected
      Rails.cache.fetch("FlatsHist#last_collected", expires_in: 1.hours) { where(date: last_date).count(:id) }
    end
  end
end
