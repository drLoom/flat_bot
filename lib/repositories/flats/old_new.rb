# frozen_string_literal: true

module Repositories
  module Flats
    class OldNew
      def initialize
      end

      def call
        sql = <<~SQL
          with old_new as (
            select object_id, min(date) as min_dt, max(date) as max_dt from flats_hist group by object_id
          ),
          dates as (
            select distinct date from flats_hist
          )
          select dates.date, old_cnt, new_cnt
            from dates
            left join (select max_dt, count(object_id) as old_cnt from old_new group by max_dt) as old_ on dates.date = old_.max_dt
            left join (select min_dt, count(object_id) as new_cnt from old_new group by min_dt) as new_ on dates.date = new_.min_dt
          order by dates.date
        SQL

        result = ApplicationRecord.connection.execute(sql).to_a

        # ignore for start and end as all are new at the start, and all are old at the end
        result.first['new_cnt'] = nil
        result.last['old_cnt']  = nil

        result
      end
    end
  end
end
