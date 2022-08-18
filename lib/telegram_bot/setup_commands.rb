# frozen_string_literal: true

module TelegramBot
  class SetupCommands

    attr_reader :client

    def initialize
      @client = Client.new(logger: Rails.logger)
    end

    def set
      commands = [
        { 'command' => '/start', 'description' => 'Начать' },
        { 'command' => '/stats', 'description' => 'Посмотреть статистику' },
        { 'command' => '/feedback', 'description' => 'Оставьте отзыв' }
      ]

      res = client.post('setMyCommands', { commands: commands })
    end
  end
end
