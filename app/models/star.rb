# frozen_string_literal: true

class Star < ApplicationRecord
  belongs_to :user

  belongs_to :latest_hist, -> { latest },
    class_name: 'FlatsHist', inverse_of: :star, foreign_key: :object_id, primary_key: :object_id

  belongs_to :begined_hist, -> { begined },
    class_name: 'FlatsHist', inverse_of: :star, foreign_key: :object_id, primary_key: :object_id
end
