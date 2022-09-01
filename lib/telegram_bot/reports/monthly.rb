# frozen_string_literal: true

module TelegramBot
  module Reports
    class Monthly
      attr_reader :client

      FIELDS_MAPPING = {
        'avg_price'       => 'Цена',
        'avg_meter_price' => 'Цена м²',
        'avg_area'        => 'Количество метров'
      }.freeze

      def initialize
        @client = Client.new(logger: Rails.logger)
      end

      def send
        count = TUser.count
        TUser.find_each.with_index(1) do |u, idx|
          Rails.logger.info "Processing user: #{u.id} (#{idx} / #{count})"

          res = client.send_message(chat_id: u.chat_id, text: report, parse_mode: 'MarkdownV2')

          sleep 0.5
        end
      end

      private

      def report
        @report ||= begin
          curr_dt = Date.current
          min_dt  = FlatsHist.where(date: (curr_dt - 1.month).beginning_of_month..curr_dt).minimum(:date)

          previous = current(min_dt).index_by { |r| r.rooms.to_i }
          current  = current(curr_dt).index_by { |r| r.rooms.to_i }

          body = (current.keys + previous.keys).sort.uniq.map do |rooms|
            report_row(rooms, previous[rooms], current[rooms])
          end.join("\n")

          "Статистика за *#{min_dt} - #{curr_dt}*\n#{body}"
            .gsub('.', '\\.').gsub('-', '\\-').gsub('(', '\\(').gsub(')', '\\)')
        end
      end

      def current(date)
        FlatsHist.where(date: date)
          .select(
            <<~SQL
              rooms,
              AVG(price_usd) AS avg_price,
              AVG(price_usd / area) AS avg_meter_price,
              AVG(area) AS avg_area
            SQL
        ).group(:rooms)
      end

      def report_row(rooms, previous, current)
        attrs = %w[avg_price avg_meter_price avg_area]
        attrs.map do |attr|
          prev, curr = previous&.[](attr), current&.[](attr)
          diff, diff_pct = calc_diff(prev, curr)

          <<~ROW
            *#{rooms}* - #{FIELDS_MAPPING[attr]}: #{prev&.round(2)} - #{curr.round(2)}. Изменение: #{diff}, (#{diff_pct}%)
          ROW
        end.join
      end

      def calc_diff(prev, curr)
        diff     = (curr - prev).round(2)
        diff_pct = (diff.to_f / prev * 100).round(2)

        [diff, diff_pct]
      end
    end
  end
end
