Jets.application.routes.draw do
  root "hello#index"
  match "/", to: "hello#index", via: [:get, :head]
end