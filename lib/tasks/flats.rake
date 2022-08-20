# frozen_string_literal: true

namespace :flats do
  desc 'Collect fresh flats'
  task collect: :environment do
    Flats::Collector.new.collect
  end
end

namespace :t_bot do
  desc 'Set bot commands'
  task set_commands: :environment do
    TelegramBot::SetupCommands.new.set
  end

  desc 'Start polling'
  task start_pooling: :environment do
    TelegramBot::Reception.new.open
  end

  desc 'Send notifications'
  task send_notifications: :environment do
    TelegramBot::SendNotifications.new.send
  end

  desc 'Send price change notifications'
  task send_pc_notifications: :environment do
    TelegramBot::SendNotifications.new.send_pc
  end
end

namespace :test do
  desc 'Test'
  task test: :environment do
    TelegramBot::Reception.new.open
  end
end
