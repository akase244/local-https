ssl_bind '0.0.0.0', '9293',
  cert: '/certs/snakeoil.crt',
  key:  '/certs/snakeoil.key',
  verify_mode: 'none'

workers 0
threads 1, 5
preload_app!