StartUp::Application.routes.draw do

  resources :posts do
    resources :comments, :only => [:create, :destroy]
  end

  namespace :admin do
    get 'home/index'
    root :to => "home#index"

    get 'resque', :to => "home#resque"
    mount Resque::Server.new => 'resque_panel', :as => 'resque_panel'
  end


  post 'kindeditor/upload', :to => 'kindeditor/assets#create'

  devise_for :user, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations"}
  devise_scope :user do
    get 'user/binding', :to => 'users/registrations#binding'
    post 'user/bind', :to => 'users/registrations#bind'
    put 'user/update_profile', :to => 'users/profiles#update_profile'
  end
  match "profiles/:id" => "users/profiles#show"

  get "home/index"

  root :to => "home#index"
end
