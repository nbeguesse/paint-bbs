Paint::Application.routes.draw do

  resources :comments


  resources :boards do
    resources :posts do
      collection do
        post :save
        get :doodle
        get :upload
      end
      member do
        get :doodle
      end
    end
  end


  resources :users


  resources :topics
  resources :password_resets
  resource :user_sessions

  root :to => 'boards#show'
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login
  get 'pages/faq' => 'pages#faq', :as => :faq
  get 'pages/rules' => 'pages#rules', :as => :rules
  get 'pages/privacy' => 'pages#privacy', :as => :privacy_policy
  get 'posts/:slug' => 'posts#show', :as=>:share
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
