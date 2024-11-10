Rails.application.routes.draw do
  post 'auth/login', to: 'auth#login'
  post 'auth/register', to: 'auth#register'
  # post 'auth/refresh', to: 'auth#register'

  get '/profile', to: 'users#current'
  get '/users/:username', to: 'users#show_by_username'
  post '/logout', to: 'users#logout'
  post '/logout_of_all_devices', to: 'users#logout_of_all_devices'

  resources :cards
end
