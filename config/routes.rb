Rails.application.routes.draw do
  namespace :v1 do
    resources :users, param: :uniqname, only: ['show', 'update'] do
      resources :loans, only: ['index']
    end
  end
end
