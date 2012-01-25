WorkplaceResearch::Application.routes.draw do
  resource :session

  resources :surveys do
    get 'preview', on: :member
    delete 'clear', on: :member
    resources :responses do
      post 'submit', on: :collection
    end
  end

  match '/auth/:provider/callback', to: 'sessions#callback'

  root to: 'surveys#index'
end
