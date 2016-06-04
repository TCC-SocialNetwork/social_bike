Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, class_name: 'SocialFramework::User',
    controllers: {sessions: 'users/sessions',
                  registrations: 'users/registrations',
                  passwords: 'users/passwords'}

  post :search, to: 'home#search'
  post 'add_friend/:id', to: 'home#add_friend', as: :add_friend
  post 'accept_friend/:id', to: 'home#accept_friend', as: :accept_friend
  post 'remove_friend/:id', to: 'home#remove_friend', as: :remove_friend
end
