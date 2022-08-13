# frozen_string_literal: true

God.pid_file_directory = File.expand_path('../../../tmp/god_pids', __FILE__)
God.watch do |w|
  w.name = "tpooling"
  w.log = File.expand_path('../../../log/tpooling.log' ,__FILE__)

  rake_file = File.expand_path('../../../lib/tasks/flats.rake' ,__FILE__)

  root_path = File.expand_path('../../../' ,__FILE__)

  w.env = { 'RAILS_ENV' => "production" }

  w.start = "cd #{root_path}; bundle exec rake t_bot:start_pooling"
  w.keepalive
end
