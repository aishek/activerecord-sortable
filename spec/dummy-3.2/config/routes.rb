Dummy::Application.routes.draw do
  resources :parents, :only => [:new, :create, :show]
  resources :things, :only => [:index] do
    member do
      post :move
    end
  end

  root :to => 'things#index'
end
