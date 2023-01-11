# frozen_string_literal: true

module TelegramBot
  class Dispatcher
    attr_reader :update, :user_model, :user, :cmd

    def initialize(update:, user_model: TUser)
      @update     = update
      @user_model = user_model
      @cmd        = nil
      @user       = nil
    end

    def dispatch
      @cmd  = extract_cmd
      @user = extract_user
    end

    def extract_cmd
      @cmd = if message?
               update_message['text']
             elsif callback_query?
               callback_query['data']
             end
    end

    def extract_user
      params = user_info(message_from_update)
      @user  = user_model.find_by(params) || user_model.create!(params)
    end

    private

    def message_from_update
      update_message || callback_query&.[]('message') || update['my_chat_member']
    end

    def message?
      update_message.present?
    end

    def callback_query?
      callback_query.present?
    end

    def update_message
      @update_message ||= update['message']
    end

    def callback_query
      @callback_query ||= update['callback_query']
    end

    def user_info(message)
      { tid: message['from']['id'], chat_id: message['chat']['id'] }
    end
  end
end
