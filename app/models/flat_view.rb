# frozen_string_literal: true

class FlatView < ApplicationRecord
  self.table_name = 'flats_view'

  has_one :star, class_name: 'Star', foreign_key: :object_id, primary_key: :object_id

  belongs_to :latest_hist, class_name: 'FlatsHist', foreign_key: :max_id, primary_key: :id
  belongs_to :begined_hist, class_name: 'FlatsHist', foreign_key: :min_id, primary_key: :id
end
