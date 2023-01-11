# frozen_string_literal: true
class AddFlatsView < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE VIEW flats_view AS
        SELECT object_id,
          max(date) AS max_date,
          max(id) AS max_id,
          min(date) AS min_date,
          min(id) AS min_id
        FROM flats_hist
        GROUP BY object_id
      ;
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS flats_view
    SQL
  end
end
