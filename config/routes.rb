Rails.application.routes.draw do
  # 管理者用のDeviseルーティング
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ユーザー用のDeviseルーティング
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # ユーザーのゲストログイン用ルーティング
  devise_scope :user do
    post 'guest_login', to: 'public/sessions#guest_login'
  end

  # 管理者用のルーティングスコープ
  namespace :admin do
    root to: "homes#top"
    resources :profile_icons, only: [:new, :index, :create, :destroy]
    resources :tags, only: [:index, :create, :destroy]
    resources :users, only: [:index, :show, :update] do
      get 'search_messages', on: :member
      collection do
        get 'search_users'
        get 'search_all_messages'
        get 'suggest_users'
        get 'suggest_messages'
      end
    end
  end

  # ユーザー用のルーティングスコープ
  scope module: :public do
    root to: "homes#top"
    get "about", to: "homes#about"
    get 'users/dummy', to: 'users#dummy'
    post 'notifications/mark_as_read', to: 'notifications#mark_as_read'
    
    resources :groups, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      get 'suggest_game_title', on: :collection
      member do
        get 'join'
        delete 'leave'
        get 'user_count'
        get 'user_list'
      end
      resources :messages
    end

    resources :users, only: [:show, :edit, :update] do
      member do
        get :blocking_users
        post 'block/:id', to: 'relationships#block', as: 'block'
        delete 'unblock/:id', to: 'relationships#unblock', as: 'unblock'
      end
      resources :profile_icons, only: [:index, :update]
    end
  end
end
