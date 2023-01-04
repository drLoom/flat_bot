class Stars < ActiveRecord::Migration[7.0]
  def change
    create_table :stars do |t|
      t.bigint :user_id
      t.bigint :object_id

      t.timestamps
    end
    add_index :stars, %i[user_id object_id], unique: true
  end
end
