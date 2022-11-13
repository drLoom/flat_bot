# frozen_string_literal: true

module Repositories
  module Flats
    class IncDec
      def call
        sql = <<~SQL
          select
          date,
          sum(
            case
              when price_usd < previous_price then 1
              else 0
            end
          ) as declines,
          sum(
            case
              when price_usd > previous_price then 1
              else 0
            end
          ) as increses
          from
            (
              select
                date,
                object_id,
                price_usd,
                lag(price_usd, 1) over (
                  partition by object_id
                  order by
                    date
                ) previous_price
              from
                flats_hist
            ) t
          group by date
          order by date
        SQL

        result = ApplicationRecord.connection.execute(sql).to_a

        result
      end
    end
  end
end
