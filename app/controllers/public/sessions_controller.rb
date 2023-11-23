# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # ユーザーのアクティブ状態を確認するためのフィルター
  before_action :confirm_is_active, only: [:create]

  # ゲストユーザーのログイン
  def guest_login
    user = User.create_guest
    sign_in user
    redirect_to user_path(user), notice: 'ゲストユーザーとしてログインしました。'
  end

  # ログアウトアクション
  def destroy
    if current_user && !current_user.is_active?
      # ユーザーが非アクティブの場合、セッションを破棄してログアウト
      sign_out current_user
      redirect_to new_user_session_path, alert: 'このアカウントは無効です。'
    else
      # 通常のログアウト処理
      super
    end
  end

  protected

  # ログアウト後のリダイレクト先を指定します
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # ユーザーのアクティブ状態を確認し、無効な場合にリダイレクトします
  def confirm_is_active
    user = User.find_by(email: params[:user][:email])
    if user && !user.is_active?
      redirect_to new_user_session_path, alert: 'このアカウントは無効です'
    end
  end

  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
