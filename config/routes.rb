Slideapp::Application.routes.draw do
  devise_for :users
  resources :slides
  post "slides/search"
  get "slides/:id/pages" => "slides#pages"
  resources :users, :only => [:show, :index]

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
end
