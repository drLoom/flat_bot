class CreateTUsserNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :t_usser_notifications do |t|
      t.references :t_user
      t.string :rooms
      t.string :meters
      t.string :price

      t.timestamps
    end
  end
end
