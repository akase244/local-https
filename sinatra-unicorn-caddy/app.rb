require "sinatra"

set :bind, "0.0.0.0"
set :port, 4567

get "/" do
  "Hello Sinatra over HTTPS via Caddy"
end