class AddInternalIdToFlatsHist < ActiveRecord::Migration[7.0]
  def change
    add_column :flats_hist, :internal_id, :bigint
  end
end
