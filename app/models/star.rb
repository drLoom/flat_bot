# frozen_string_literal: true

class Star < ApplicationRecord
  belongs_to :user
  has_many :flats_hists,
    class_name: 'FlatsHist', inverse_of: :star, foreign_key: :object_id, primary_key: :object_id

  def first_hist
    @first_hist ||= flats_hists.sort_by(&:date).first
  end

  def latest_hist
    @latest_hist ||= flats_hists.sort_by(&:date).last
  end
end
