StartUp::Application.routes.draw do

  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'

  resources :posts do
    resources :comments, :only => [:create, :destroy]
  end

  namespace :admin do
    get 'home/index'
    root :to => "home#index"

    # Resque authorization
    resque_constraint = lambda do |request|
      # authenticate! will return a user instance
      user = request.env['warden'].authenticate!(:database_authenticatable, :scope => :user )

      return false if user.nil?
      user.admin? ? true : false
    end

    constraints resque_constraint do
      get 'resque', :to => "home#resque"
      mount Resque::Server.new, :as => 'resque_panel', :at => "resque_panel"
    end
  end

  match 'district/:id' => 'district#show'
  post 'kindeditor/upload', :to => 'kindeditor/assets#create'

  # User friendly exception handling
  match "/404", :to => "errors#not_found"
  match "/500", :to => "errors#error_occurred"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => "users/registrations"} do
    namespace :users do
      match 'auth/:action/cancel', :to => "omniauth_cancel_callbacks#:action", :as => 'cancel_omniauth_callback'
      get 'binding', :to => 'registrations#binding'
      post 'binding', :to => 'registrations#bind'
      put 'profile', :to => 'profiles#update'
    end
  end
  match "profiles/:id" => "users/profiles#show"

  root :to => "home#index"
end
