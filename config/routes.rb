Rails.application.routes.draw do
  #ユーザー側
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  #管理者側
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  #管理者側
  namespace :admin do
    get "/", to: "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
  end
  #ユーザー側
  scope module: :public do
    root "homes#top"
    get 'block_users/index', to: "block_users#index"
    resources :groups, only: [:index, :show, :new, :edit, :create, :update, :destroy]
    resources :messages, only: [:create, :destroy]
    resources :users, only: [:show, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
