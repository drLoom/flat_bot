class AddPriceDirectionToTUsserNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :t_usser_notifications, :price_direction, :string
  end
end
