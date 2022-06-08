Rails.application.routes.draw do
  namespace :v1, defaults: {format: :json} do
    resources :users, param: :uniqname, only: ["show", "update"], constraints: {uniqname: /.*/} do
      resources :loans, only: ["index"]
      get "/loans/download", to: "loans#download"
    end
  end
end
