# frozen_string_literal: true

module TelegramBot
  class SendNotifications
    include ActionView::Helpers::NumberHelper

    attr_reader :client

    def initialize
      @client = Client.new(logger: Rails.logger)
    end

    def send
      users = TUser.joins(:notifications).includes(:notifications)
      users.each.with_index(1) do |u, idx|
        Rails.logger.info "Processing user: #{u.id} (#{idx} / #{users.size})"

        u.notifications.each do |n|
          flats = flats(n.rooms)
          flats.order(price_usd: :desc).limit(10).each do |f|
            text = escape_str(present_flat(f))

            res = client.post('sendPhoto', { chat_id: u.chat_id, caption: text, photo: f.photo, parse_mode: 'MarkdownV2' })
            sleep 0.5
          end
        end
      end
    end

    private

    def flats(rooms_cond)
      case rooms_cond
      when '1', '2', '3', '4'
        FlatsHist.newly.where(rooms: rooms_cond)
      end
    end

    def present_flat(f)
      <<~FLAT
        *Цена:* #{number_to_currency(f.price_usd, precision: 0, delimiter: ' ')}
        *Площадь:* #{f.area}
        *Адрес:* #{f.adress}
        *Этаж:* #{f.floor} \\(#{f.number_of_floors}\\)
        [#{f.object_id}](#{f.url})
      FLAT
    end

    def escape_str(str)
      str.gsub('.', '\\.')
    end
  end
end
