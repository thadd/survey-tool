WorkplaceResearch::Application.routes.draw do
  resources :surveys
  resource :session

  match '/auth/:provider/callback', to: 'sessions#callback'

  root to: 'surveys#index'
end
