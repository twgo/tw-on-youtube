Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/s'

  root 'videos#new'

  get 'refresh_videos', to: "videos#refresh_videos"

  resources :videos, only: %i[index new create] do
    collection do
      get 'get_vtt'
      get 'redownload'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
