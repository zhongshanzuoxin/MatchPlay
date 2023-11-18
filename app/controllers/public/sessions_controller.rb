# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # ユーザーのアクティブ状態を確認するためのフィルター
  before_action :confirm_is_active, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

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
