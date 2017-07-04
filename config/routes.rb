Rails.application.routes.draw do
  root to: 'shedule#low_price'
  # resources :movies
  post '/searchmovie', to: 'shedule#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get '/seanses', to: 'shedule#low_price'
  get '/movietitles', to: 'movies#titles'
end
