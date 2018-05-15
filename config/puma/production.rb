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