AmethystSprites::Application.routes.draw do
  default_url_options :host => "amethyst-sprites.heroku.com"
  
  get 'log_out' => 'sessions#destroy', :as => 'log_out'
  get 'log_in' => 'sessions#new', :as => 'log_in'
  get 'sign_up' => 'artists#new', :as => 'sign_up'
  post 'sign_up' => 'artists#create'
  
  get 'forgot' => 'password_resets#new', :as => 'forgot'
  post 'forgot' => 'password_resets#new'
  
  get 'palette' => 'palette#index', :as => 'palette'
  post 'palette' => 'palette#index'
  
  resources :artists do
    get :work, :on => :member
  end
  
  resources :password_resets
  resources :sessions
  resources :activities
  
  resources :sprites do
    resources :comments
  end
  
  match 'pokemon/:name(/:form)' => 'pokemon#show', :constraints => {:name => /[A-Z][^\/]+/}, :as => 'named_pokemon', :via => :get

  resources :pokemon do
    resources :series
    member do
      get :claim
      get :unclaim
    end
  end
  
  resources :series do
    resources :sprites do
      post :submit, :on => :collection
    end
    match 'transition/:event' => 'series#transition', :on => :member, :as => :transition, :via => :get
  end
  
  root :to => 'pokemon#index'

end
