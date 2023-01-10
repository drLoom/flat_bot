# frozen_string_literal: true

class AddIdxToFlatHist < ActiveRecord::Migration[7.0]
  def change
    add_index :flats_hist, %i[object_id date]
  end
end
