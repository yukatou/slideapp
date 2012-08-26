Slideapp::Application.routes.draw do
  devise_for :users

  get "slides/:id/\#!/viewer" => "slides#show", :as => "slide"
  get "slides/:id/\#!/presenter" => "slides#show", :as => "slide_presenter"
  post "slides/search"
  get "slides/:id/pages" => "slides#pages"


  resources :slides

  authenticated :user do
    root :to => 'home#index'
  end

  resources :users, :only => [:show, :index]

  root :to => "home#index"
end
