AmethystSprites::Application.routes.draw do
  devise_for :artists
  
  match 'pokemon/:name(/:form)' => 'pokemon#show', :constraints => {:name => /[A-Z][^\/]+/}, :as => 'named_pokemon', :via => :get

  resources :pokemon do
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
