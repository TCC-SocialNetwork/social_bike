Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, class_name: 'SocialFramework::User',
    controllers: {sessions: 'users/sessions',
                  registrations: 'users/registrations',
                  passwords: 'users/passwords'}
end
