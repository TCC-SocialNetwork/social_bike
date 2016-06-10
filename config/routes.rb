Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, class_name: 'SocialFramework::User',
    controllers: {sessions: 'sessions',
                  registrations: 'registrations',
                  passwords: 'users/passwords'}

  post :search, to: 'home#search'
  post 'add_friend/:id', to: 'home#add_friend', as: :add_friend
  post 'accept_friend/:id', to: 'home#accept_friend', as: :accept_friend
  post 'remove_friend/:id', to: 'home#remove_friend', as: :remove_friend

  get :new_event, to: 'events#new'
  post :create_event, to: 'events#create'
  get 'event/:id', to: 'events#show', as: :event
  post 'enter_in_event/:id', to: 'events#enter', as: :enter_in_event
  post 'invite/:id/:user_id', to: 'events#invite', as: :invite
  post 'remove_participant/:id/:user_id', to: 'events#remove_participant', as: :remove_participant
  post 'accept_invitation/:id', to: 'events#accept_invitation', as: :accept_invitation
end
