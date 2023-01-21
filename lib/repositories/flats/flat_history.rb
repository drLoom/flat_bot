# frozen_string_literal: true

module Repositories
  module Flats
    class FlatHistory
      def call(object_id)
        binds = [ActiveRecord::Relation::QueryAttribute.new('object_id', object_id, ActiveRecord::Type::Integer.new)]
        results = ActiveRecord::Base.connection.exec_query(<<~SQL, 'sql', binds)
          select *
          from
          (
            select
              date,
              object_id,
              price_usd,
              lag(price_usd, 1) over (
                partition by object_id
                order by date
              ) previous_price
            from flats_hist
            where object_id = $1
            order by date
          ) t
          where previous_price <> price_usd or previous_price is null
        SQL

        results
      end
    end
  end
end
