# frozen_string_literal: true

God.pid_file_directory = 'config/god_pids'
God.watch do |w|
  w.name = "tpooling"
  w.log = 'log/tpooling.log'

  w.start = "rake t_bot:start_pooling"
  w.keepalive
end
