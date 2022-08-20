# frozen_string_literal: true

require 'faraday'

module TelegramBot
  class Client
    attr_accessor :url, :token, :logger
    attr_reader :conn

    def initialize(url: 'https://api.telegram.org', token: Rails.application.credentials.real_e_m_bot[:token], logger: Logger.new("/dev/null"))
      @url, @token = url, token
      @logger      = logger

      set_connection!
    end

    def get_updates
      polling = true
      Signal.trap("INT") { polling = false }
      offset = 0
      while polling
        logger.info 'Polling'
        results = conn.get('getUpdates', { offset: offset, timeout: 3 }).body['result'].each do |result|
          logger.info result.inspect

          yield result

          offset = result['update_id'] + 1
        end
      end
    end

    def send_message(**opts)
      post('sendMessage', opts)
    end

    def post(meth, params)
      response = conn.post(meth, params)

      if !response.success?
        logger.error "Failed to send message. #{response.inspect}. Params: #{params.inspect}"
      end

      response
    end

    def set_connection!
      @conn = Faraday.new(base_url) do |f|
        f.request :json # encode req bodies as JSON and automatically set the Content-Type header
        #f.request :retry # retry transient failures
        f.response :json # decode response bodies as JSON
        #f.adapter :net_http # adds the adapter to the connection, defaults to `Faraday.default_adapter`
      end
    end

    private

    def base_url
      @base_url ||= "#{url}/bot#{token}/"
    end
  end
end
