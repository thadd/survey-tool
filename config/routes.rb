WorkplaceResearch::Application.routes.draw do
  resource :session

  resources :surveys do
    get 'preview', on: :member
  end

  match '/auth/:provider/callback', to: 'sessions#callback'

  root to: 'surveys#index'
end
