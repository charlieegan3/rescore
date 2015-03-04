Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'
  get 'about' => 'application#about', as: :about
  get 'stats' => 'statistics#index', as: :stats

  get 'stats/refresh' => 'statistics#refresh', as: :stats_refresh

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  get 'movies/new_from_lookup' => 'movies#new_from_lookup', as: :new_movie_from_lookup
  get 'movies/search_by_title' => 'movies#search_by_title'
  get 'movies/compare' => 'movies#compare', as: :compare_movies
  get 'movies/admin' => 'movies#admin', as: :movie_admin
  get 'movies/:id/status' => 'movies#status', as: :movie_status
  get 'movies/:id/manage' => 'movies#manage', as: :manage_movie
  get 'movies/:id/populate_source_links' => 'movies#populate_source_links', as: :populate_movie_source_links
  get 'movies/:id/populate_related_people' => 'movies#populate_related_people', as: :populate_movie_related_people
  get 'movies/:id/collect' => 'movies#collect', as: :collect_movie
  get 'movies/:id/build_summary' => 'movies#build_summary', as: :build_movie_summary
  get 'movies/:id/favorite' => 'favorites#set', as: :favorite_movie
  resources :movies


  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
