
if Rails.env.development?
  dir = ENV['PWD']
  sdir = ENV['PWD']

  port 3000
  threads 5, 64
  environment 'development'
  directory dir
  daemonize false

  bind "unix://#{File.expand_path('tmp/sockets/puma.sock', sdir)}"
  pidfile "#{File.expand_path('tmp/pids/puma.pid', sdir)}"
  state_path "#{File.expand_path('tmp/sockets/puma.state', sdir)}"
  activate_control_app "unix://#{File.expand_path('tmp/sockets/pumactl.sock', sdir)}"

  on_restart do
    puts '- * - On restart - * -'
    puts 'pidfile: '
    puts @options[:pidfile]
    puts 'binds: '
    puts @options[:binds]
    puts 'control_url: '
    puts @options[:control_url]
    puts '- * - * - * -'
  end
else
  app_root = '/data/www/homeland'
  pidfile "#{app_root}/shared/tmp/pids/puma.pid"
  state_path "#{app_root}/shared/tmp/pids/puma.state"
  stdout_redirect "#{app_root}/shared/log/puma.stdout.log", "#{app_root}/shared/log/puma.stderr.log", true
  bind 'unix:/tmp/homeland.puma.sock'
  daemonize true
  port 7000
  workers 1
  threads 2, 32
  preload_app!

end







on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end
