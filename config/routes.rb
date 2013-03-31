StartUp::Application.routes.draw do

  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'

  resources :posts do
    resources :comments
  end

  namespace :admin do
    root :to => 'home#index'
  end

  match 'district/:id' => 'district#show'

  mount UeditorRails::Engine => '/ueditor'
  post 'ueditor/file', :to => 'ueditor/assets#file'
  post 'ueditor/image', :to => 'ueditor/assets#image'

  # User friendly exception handling
  match '/404', :to => 'errors#not_found'
  match '/500', :to => 'errors#error_occurred'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks',
                                       :registrations => 'users/registrations'} do
    namespace :users do
      match 'auth/:action/cancel', :to => 'omniauth_cancel_callbacks#:action', :as => 'cancel_omniauth_callback'
      get 'binding', :to => 'registrations#binding'
      post 'binding', :to => 'registrations#bind'
      put 'profile', :to => 'profiles#update'
    end
  end
  get 'profiles/:id' => 'users/profiles#show'

  root :to => 'home#index'
end
