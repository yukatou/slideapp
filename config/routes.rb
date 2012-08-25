Slideapp::Application.routes.draw do
  devise_for :users
  resources :slides
  post "slides/search"
  resources :users, :only => [:show, :index]

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
end
