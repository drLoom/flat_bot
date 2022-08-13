class TUser < ActiveRecord::Migration[7.0]
  def change
    create_table :t_users do |t|
      t.bigint :tid
      t.boolean :is_bot
      t.string :first_name
      t.string :username
      t.string :language_code
      t.bigint :chat_id
      t.string :chat_type

      t.timestamps
    end

    add_index :t_users, %i[tid chat_id], unique: true
  end
end
