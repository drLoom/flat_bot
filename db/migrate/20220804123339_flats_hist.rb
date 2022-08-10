class FlatsHist < ActiveRecord::Migration[7.0]
  def change
    create_table :flats_hist do |t|
      t.date :date
      t.bigint :object_id
      t.decimal :area, precision: 6, scale: 2
      t.decimal :price, precision: 10, scale: 2
      t.decimal :price_usd, precision: 10, scale: 2
      t.float :rooms
      t.string :url
      t.jsonb :data

      t.timestamps
    end

    add_index :flats_hist, %i[date object_id], unique: true
    add_index :flats_hist, %i[date id], unique: true
  end
end
