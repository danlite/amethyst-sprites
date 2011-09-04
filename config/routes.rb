AmethystSprites::Application.routes.draw do
  
  get 'log_out' => 'sessions#destroy', :as => 'log_out'
  get 'log_in' => 'sessions#new', :as => 'log_in'
  get 'sign_up' => 'artists#new', :as => 'sign_up'
  
  resources :artists
  resources :sessions
  
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
