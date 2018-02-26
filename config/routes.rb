Rails.application.routes.draw do
  root 'videos#new'

  resources :videos, only: %i[index new create] do
    collection do
      get 'get_vtt'
      get 'redownload'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
