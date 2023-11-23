Rails.application.routes.draw do
  #管理者側
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  #ユーザー側
devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# ゲストログインのルーティング
devise_scope :user do
  post 'guest_login', to: 'public/sessions#guest_login'
end

  #管理者側
  namespace :admin do
    get "/", to: "homes#top"
    resources :icons, only: [:new, :create, :index, :destroy]
    resources :users, only: [:index, :show, :edit, :update] do
      get 'search_messages', on: :member
    end
  end

  #ユーザー側
  scope module: :public do
    root "homes#top"
    get 'users', to: 'users#dummy'
    post 'notifications/mark_as_read', to: 'notifications#mark_as_read'
    resources :groups, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      get 'search', to: 'groups#search'
      resources :messages
        member do
      get 'join'
      delete 'leave'
      get 'user_count'
      get 'user_list'
    end
  end

    resources :users, only: [:show, :edit, :update] do
        member do
        get :blocking_users
        resources :icons, only: [:index, :update]
        post 'block/:id' => 'relationships#block', as: 'block'
        delete 'unblock/:id' => 'relationships#unblock', as: 'unblock'
      end
    end
  end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

