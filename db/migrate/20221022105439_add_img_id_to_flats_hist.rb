# frozen_string_literal: true

class AddImgIdToFlatsHist < ActiveRecord::Migration[7.0]
  def change
    add_column :flats_hist, :img_id, :bigint
  end
end
