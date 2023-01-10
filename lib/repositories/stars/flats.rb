# frozen_string_literal: true

module Repositories
  module Stars
    class Flats
      def call(object_ids)
        sql = <<~SQL
          SELECT
          date,
          object_id,
          ROUND(price_usd / area) AS meter_price
          FROM flats_hist
          WHERE object_id IN (:object_ids)
          ORDER BY 1, 2
        SQL

        ApplicationRecord.connection.execute(ApplicationRecord.sanitize_sql([sql, { object_ids: object_ids }])).to_a
      end
    end
  end
end
