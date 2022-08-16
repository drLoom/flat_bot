# frozen_string_literal: true

class FlatsHist < ApplicationRecord
  self.table_name = 'flats_hist'

  class << self
    def last_date
      Rails.cache.fetch("FlatsHist#last_date", expires_in: 1.hours) { maximum(:date) }
    end

    def last_collected
      Rails.cache.fetch("FlatsHist#last_collected", expires_in: 1.hours) { where(date: last_date).count(:object_id) }
    end

    def last_newly
      Rails.cache.fetch("FlatsHist#last_newly", expires_in: 1.hours) { newly.count(:object_id) }
    end

    [1, 2, 3, 4].each do |i|
      m_name_r = "recent#{i}".to_sym
      define_method(m_name_r) do
        Rails.cache.fetch("FlatsHist##{m_name_r}", expires_in: 1.hours) do
          recent.where(rooms: i).count(:object_id)
        end
      end

      m_name_n = "newly#{i}".to_sym
      define_method(m_name_n) do
        Rails.cache.fetch("FlatsHist##{m_name_n}", expires_in: 1.hours) do
          newly.where(rooms: i).count(:object_id)
        end
      end
    end

    def newly5
      Rails.cache.fetch("FlatsHist#newly5", expires_in: 1.hours) do
        newly.where('rooms >= 5').count(:object_id)
      end
    end

    def recent5
      Rails.cache.fetch("FlatsHist#recent5", expires_in: 1.hours) do
        recent.where('rooms >= 5').count(:object_id)
      end
    end
  end

  scope :recent, -> { where(date: last_date) }
  scope :newly, -> do
     recent
     .where.not(object_id: FlatsHist.where('date < ?', last_date).select(:object_id))
     .where('created_at = updated_at')
  end

  def photo
    data['photo']
  end

  def adress
    data['location']['address']
  end

  def floor
    data['floor']
  end

  def number_of_floors
    data['number_of_floors']
  end
end
