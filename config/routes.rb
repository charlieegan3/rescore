Rails.application.routes.draw do
  root 'application#index'

  get 'movies/new_from_lookup' => 'movies#new_from_lookup', as: :new_movie_from_lookup
  get 'movies/search_by_title' => 'movies#search_by_title'
  get 'movies/admin' => 'movies#admin', as: :movie_admin
  get 'movies/:id/status' => 'movies#status', as: :movie_status
  get 'movies/:id/manage' => 'movies#manage', as: :manage_movie
  get 'movies/:id/build' => 'movies#build', as: :build_movie
  get '/movies', to: redirect('/')
  resources :movies

  get 'stats/refresh' => 'statistics#refresh', as: :stats_refresh
end
