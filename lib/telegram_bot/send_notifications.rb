# frozen_string_literal: true

module TelegramBot
  class SendNotifications

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
          flats.limit(10).each do |f|
            text = escape_str(present_flat(f))

            client.post('sendMessage', { chat_id: u.chat_id, text: text, parse_mode: 'MarkdownV2' })
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
        *Price$:* #{f.price_usd.round}
        *Area:* #{f.area}
        [#{f.object_id}](#{f.url})
      FLAT
    end

    def escape_str(str)
      str.gsub('.', '\\.')
    end
  end
end
