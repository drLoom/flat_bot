# frozen_string_literal: true

class AddNtypeToTUsserNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :t_usser_notifications, :ntype, :string
  end
end
