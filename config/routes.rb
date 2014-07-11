Selfstarter::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => 'home#index'
  match '/preorder'               => 'preorder#index', :via => [:get,:post]
  get 'preorder/checkout'
  match '/preorder/share/:uuid'   => 'preorder#share', :via => :get
  match '/preorder/ipn'           => 'preorder#ipn', :via => :post
  match '/preorder/prefill'       => 'preorder#prefill', :via => [:get,:post]
  match '/preorder/postfill'      => 'preorder#postfill', :via => [:get,:post]
  #match '/home', to: 'home#index', :via => [:get,:post], as: :home
  match '/home', to: 'home#tileapp', :via => [:get,:post], as: :home
  match '/price-list', to: 'home#price_list', :via => :get, as: :price_list
  match '/showcase', to: 'home#showcase', :via => :get, as: :showcase
  get '/checkout' => 'orders#checkout'
  resources :charges
  resources :orders
end
