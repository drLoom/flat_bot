# frozen_string_literal: true

module Repositories
  module Flats
    class Doubles
      def call
        sql = <<~SQL
          SELECT date, sum(cnt) as doubles FROM (
            select date, img_id, count(distinct object_id) cnt from flats_hist
            group by date, img_id
            having count(distinct object_id) > 1
          ) t GROUP BY date
        SQL

        ApplicationRecord.connection.execute(sql).to_a
      end
    end
  end
end
