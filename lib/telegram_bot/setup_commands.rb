# frozen_string_literal: true

module TelegramBot
  class SetupCommands

    attr_reader :client

    def initialize
      @client = Client.new(logger: Rails.logger)
    end

    def set
      commands = [
        { 'command' => '/stats', 'description' => 'See bots stats' },
        { 'command' => '/settings', 'description' => 'Set notification rules' },
        #{ 'command' => '/feedback', 'description' => 'Оставте отзыв' }
      ]

      res = client.post('setMyCommands', { commands: commands })
    end
  end
end
