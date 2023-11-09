Rails.application.routes.draw do

  namespace :public do
    get 'rooms/show'
  end
  #管理者側
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  #ユーザー側
devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  #管理者側
  namespace :admin do
    get "/", to: "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
  end
  
  #ユーザー側
  scope module: :public do
    root "homes#top"
    resources :groups, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      resources :messages
        member do
      get 'join'
      delete 'leave'
    end
  end

    resources :users, only: [:show, :update] do
        member do
        get :blocked_users
      end
    end 
    get 'block/:id' => 'relationships#block', as: 'block' 
    get 'unblock/:id' => 'relationships#unblock', as: 'unblock'
  end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

