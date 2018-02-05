Rails.application.routes.draw do
  scope module: :indicator do 
		resources :indicators
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
