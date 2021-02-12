Rails.application.routes.draw do
  namespace :v1, defaults: {format: :json} do
    resources :users, param: :uniqname, only: ['show', 'update'] do
      resources :loans, only: ['index']
    end
  end
end
