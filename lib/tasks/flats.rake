# frozen_string_literal: true

namespace :flats do
  desc 'Collect fresh flats'
  task collect: :environment do
    Flats::Collector.new.collect
  end
end

namespace :t_bot do
  desc 'Start polling'
  task start_pooling: :environment do
    TelegramBot::PollingV.new.start
  end
end

namespace :test do
  desc 'Test'
  task test: :environment do
    TelegramBot::Client.new(logger: Rails.logger).get_updates
  end
end
