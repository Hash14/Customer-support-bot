Rails.application.routes.draw do
	resources :messages
	get '/' , to: 'messages#handle_verification' 
	post '/', to: 'messages#handle_messages'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
