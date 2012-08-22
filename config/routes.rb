Slideapp::Application.routes.draw do
  get "slides/index"
  resources :slides 

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]
end
