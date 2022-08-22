# frozen_string_literal: true

module TelegramBot
  class SendNotifications
    include ActionView::Helpers::NumberHelper

    attr_reader :client

    def initialize
      @client = Client.new(logger: Rails.logger)
    end

    def send
      users = TUser.joins(:notifications).includes(:notifications).where(notifications: { ntype: 'n' })
      users.each.with_index(1) do |u, idx|
        Rails.logger.info "Processing user: #{u.id} (#{idx} / #{users.size})"

        u.notifications.each do |n|
          relation = FlatsHist.newly
          relation = by_rooms(relation, n.rooms)
          relation = by_area(relation, n.meters)
          relation = by_price(relation, n.price)
          relation.order(price_usd: :desc).limit(10).each do |f|
            text = escape_str(present_flat(f))

            res = client.post('sendPhoto', { chat_id: u.chat_id, caption: text, photo: f.photo, parse_mode: 'MarkdownV2' })
            sleep 0.5
          end
        end
      end
    end

    def send_pc
      users = TUser.joins(:notifications).includes(:notifications).where(notifications: { ntype: 'c' })
      users.each.with_index(1) do |u, idx|
        Rails.logger.info "Processing user: #{u.id} (#{idx} / #{users.size})"

        u.notifications.each do |n|
          relation = FlatsHist.recent.changed_price

          relation = by_rooms(relation, n.rooms)
          relation = by_area(relation, n.meters)
          relation = by_price(relation, n.price)
          relation = by_price_direction(relation, n.price_direction)
          relation = relation.select(relation.arel.projections, 'ABS(flats_hist.price_usd - previous_prices_flats_hist.price_usd) AS change')
          relation.order(change: :desc).limit(20).each do |f|
            text = escape_str(present_flat(f, change_price: true))

            res = client.post('sendPhoto', { chat_id: u.chat_id, caption: text, photo: f.photo, parse_mode: 'MarkdownV2' })
            sleep 0.5
          end
        end
      end
    end

    private

    def by_rooms(relation, rooms_cond)
      return relation if rooms_cond.blank?

      case rooms_cond
      when '1', '2', '3', '4'
        relation.where(rooms: rooms_cond)
      when '5+'
        relation.where('rooms >= 5')
      end
    end

    def by_area(relation, cond)
      by_condition(relation, cond, 'area')
    end

    def by_price(relation, cond)
      by_condition(relation, cond, 'price_usd')
    end

    def by_price_direction(relation, cond)
      case cond
      when '+'
        relation.where('flats_hist.price_usd > previous_prices_flats_hist.price_usd')
      when '-'
        relation.where('flats_hist.price_usd < previous_prices_flats_hist.price_usd')
      when '='
        relation
      else
        relation
      end
    end

    def by_condition(relation, cond, attr)
      return relation if cond.blank?

      case cond
      when /\Al/
        v = cond[/\d+/].to_i
        v = v * 1000 if attr == 'price_usd' # TODO:
        relation.where('#{attr} <= ?', )
      when /_/
        lv, gv = extact_interval(cond)
        lv, gv = [lv.to_i * 1000, gv.to_i * 1000] if attr == 'price_usd'
        relation.where(attr => (lv..gv))
      when /\Ag/
        v = cond[/\d+/].to_i
        v = v * 1000 if attr == 'price_usd' # TODO:
        relation.where('#{attr} >= ?', cond[/\d+/])
      end
    end

    def present_flat(f, change_price: false)
      <<~FLAT
        *Цена:* #{format_price(f.price_usd)}
        *Цена м²:* #{format_price(f.meter_price_usd)}
        *Площадь:* #{f.area}
        *Адрес:* #{f.adress}
        *Этаж:* #{f.floor} \\(#{f.number_of_floors}\\)
        #{("*Изменение цены:* #{format_price(f.previous_price.price_usd)} - #{format_price(f.price_usd)} \\(#{format_price(f.price_usd - f.previous_price.price_usd)}\\)") if change_price}
        [#{f.object_id}](#{f.url})
      FLAT
    end

    def escape_str(str)
      str.gsub('.', '\\.').gsub('-', '\\-')
    end

    def extact_interval(str)
      str.scan(/(\d+)_(\d+)/).flatten
    end

    def format_price(price)
      number_to_currency(price, precision: 0, delimiter: ' ')
    end
  end
end
