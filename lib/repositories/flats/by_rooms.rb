# frozen_string_literal: true

module Repositories
  module Flats
    class ByRooms
      def call
        sql = <<~SQL
          SELECT
          date,
          case
            when rooms >= 5 then '5+'
            else rooms :: varchar(255)
          end as rooms,
          AVG(price_usd / area) as meter_price,
          count(*) as cnt
          FROM flats_hist
          group by 1, 2
          ORDER BY 1, 2
        SQL

        ApplicationRecord.connection.execute(sql).to_a
      end
    end
  end
end
