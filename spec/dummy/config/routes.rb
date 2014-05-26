Dummy::Application.routes.draw do
  resources :things, :only => [:index] do
    member do
      post :move
    end
  end

  root 'things#index'
end
