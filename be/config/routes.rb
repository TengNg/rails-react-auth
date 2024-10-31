Rails.application.routes.draw do
  post 'auth/login', to: 'auth#login'
  post 'auth/register', to: 'auth#register'
  post 'auth/refresh', to: 'auth#refresh'
  delete 'auth/logout', to: 'auth#logout'
  delete 'auth/logout_of_all_devices', to: 'auth#logout_of_all_devices'

  get '/profile', to: 'users#current'
  get '/users/:username', to: 'users#show_by_username'

  resources :cards
end
