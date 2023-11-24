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
  
  # 一般ユーザーのログイン後の遷移先
  def after_sign_in_path_for(resource)
    user_path(resource)
  end 

  # ログアウトアクション
  def destroy
    # ゲストユーザーの場合、アカウントを削除
    if current_user&.guest?
      current_user.destroy
      redirect_to root_path, notice: 'ゲストユーザーのアカウントが削除されました。'
      return
    end
    # ユーザーが非アクティブの場合、セッションを破棄してログアウト
    if !current_user&.is_active?
      sign_out current_user
      redirect_to new_user_session_path, alert: 'このアカウントは無効になりました。'
      return
    end
    # 通常のログアウト処理
    super
  end


  protected

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # ユーザーのアクティブ状態を確認し、無効な場合にリダイレクト
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
