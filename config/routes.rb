Rails.application.routes.draw do
  scope module: :indicator do 
		resources :indicators
  end
  
  namespace :api do
    get 'index', to: 'indicator#index'
    post 'start_poll', to: 'indicator#start_poll'
    post 'stop_poll', to: 'indicator#stop_poll'
    post 'test', to: 'indicator#test'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
