Slideapp::Application.routes.draw do
  get "slides/:id/\#!/viewer" => "slides#show", :as => "slide"
  get "slides/:id/\#!/presenter" => "slides#show", :as => "slide_presenter"
  post "slides/search"
  get "slides/:id/pages" => "slides#pages"

  resources :users, :only => [:show, :index]

  devise_for :users
  resources :slides

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
