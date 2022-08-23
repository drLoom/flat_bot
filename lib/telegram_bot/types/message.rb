# frozen_string_literal: true

module TelegramBot::Types
  class Message
    attr_accessor :message_id, :from, :sender_chat, :date, :chat, :forward_from, :forward_from_chat,
                  :forward_from_message_id, :forward_signature, :forward_sender_name, :forward_date,
                  :is_automatic_forward, :reply_to_message, :via_bot, :edit_date, :has_protected_content,
                  :media_group_id, :author_signature, :text, :entities, :animation, :audio, :document, :photo,
                  :sticker, :video, :video_note, :voice, :caption, :caption_entities, :contact, :dice, :game, :poll,
                  :venue, :location, :new_chat_members, :left_chat_member, :new_chat_title, :new_chat_photo,
                  :delete_chat_photo, :group_chat_created, :supergroup_chat_created, :channel_chat_created,
                  :message_auto_delete_timer_changed, :migrate_to_chat_id, :migrate_from_chat_id, :pinned_message,
                  :invoice, :successful_payment, :connected_website, :passport_data, :proximity_alert_triggered,
                  :video_chat_scheduled, :video_chat_started, :video_chat_ended, :video_chat_participants_invited,
                  :web_app_data, :reply_markup

    def initialize(**opts)
      @message_id                        = opts['message_id']
      @from                              = opts['from']
      @sender_chat                       = opts['sender_chat']
      @date                              = opts['date']
      @chat                              = opts['chat']
      @forward_from                      = opts['forward_from']
      @forward_from_chat                 = opts['forward_from_chat']
      @forward_from_message_id           = opts['forward_from_message_id']
      @forward_signature                 = opts['forward_signature']
      @forward_sender_name               = opts['forward_sender_name']
      @forward_date                      = opts['forward_date']
      @is_automatic_forward              = opts['is_automatic_forward']
      @reply_to_message                  = opts['reply_to_message']
      @via_bot                           = opts['via_bot']
      @edit_date                         = opts['edit_date']
      @has_protected_content             = opts['has_protected_content']
      @media_group_id                    = opts['media_group_id']
      @author_signature                  = opts['author_signature']
      @text                              = opts['text']
      @entities                          = opts['entities']
      @animation                         = opts['animation']
      @audio                             = opts['audio']
      @document                          = opts['document']
      @photo                             = opts['photo']
      @sticker                           = opts['sticker']
      @video                             = opts['video']
      @video_note                        = opts['video_note']
      @voice                             = opts['voice']
      @caption                           = opts['caption']
      @caption_entities                  = opts['caption_entities']
      @contact                           = opts['contact']
      @dice                              = opts['dice']
      @game                              = opts['game']
      @poll                              = opts['poll']
      @venue                             = opts['venue']
      @location                          = opts['location']
      @new_chat_members                  = opts['new_chat_members']
      @left_chat_member                  = opts['left_chat_member']
      @new_chat_title                    = opts['new_chat_title']
      @new_chat_photo                    = opts['new_chat_photo']
      @delete_chat_photo                 = opts['delete_chat_photo']
      @group_chat_created                = opts['group_chat_created']
      @supergroup_chat_created           = opts['supergroup_chat_created']
      @channel_chat_created              = opts['channel_chat_created']
      @message_auto_delete_timer_changed = opts['message_auto_delete_timer_changed']
      @migrate_to_chat_id                = opts['migrate_to_chat_id']
      @migrate_from_chat_id              = opts['migrate_from_chat_id']
      @pinned_message                    = opts['pinned_message']
      @invoice                           = opts['invoice']
      @successful_payment                = opts['successful_payment']
      @connected_website                 = opts['connected_website']
      @passport_data                     = opts['passport_data']
      @proximity_alert_triggered         = opts['proximity_alert_triggered']
      @video_chat_scheduled              = opts['video_chat_scheduled']
      @video_chat_started                = opts['video_chat_started']
      @video_chat_ended                  = opts['video_chat_ended']
      @video_chat_participants_invited   = opts['video_chat_participants_invited']
      @web_app_data                      = opts['web_app_data']
      @reply_markup                      = opts['reply_markup']
    end
  end
end
