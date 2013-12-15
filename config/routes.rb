TopicDemo::Application.routes.draw do

  root to: "articles#index"

  resources :articles, only: [:index, :show] do
    collection { post :seed, to: "articles#seed" }
  end
  resources :discussions, only: [:show]# do
    #resources :comments, only: [:index, :create, :update]
  #end

  namespace :api, defaults: {respond_to: :json} do
    resources :articles, only: [:index, :show] do
      member { resources :discussions, only: :index }
    end

    resources :discussions, only: :show do
      resources :comments, only: [:index, :create, :update]
    end
  end

end
