worker_processes 1
timeout 30

listen "0.0.0.0:4567"

pid "/tmp/unicorn.pid"
stderr_path "/dev/stderr"
stdout_path "/dev/stdout"