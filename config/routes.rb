Rails.application.routes.draw do
  scope module: :api do
    namespace :v1 do
      post :import, to: 'imports#common'
      get '/info/:zip', to: 'population#fetch'
    end
  end
end
