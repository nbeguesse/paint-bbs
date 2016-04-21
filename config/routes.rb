Paint::Application.routes.draw do
  resources :posts


  resources :users


  resources :topics
  resources :password_resets
  resource :user_sessions

  root :to => 'posts#index'
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
