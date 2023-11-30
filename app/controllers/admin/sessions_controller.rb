# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end
  
  # 多分余りないと思いますがゲストログイン中に管理者ログインした場合ゲストが消えるように設定
  def create
    # ゲストユーザーアカウントがログイン中かどうかを確認
    if current_user&.guest?
      # ゲストユーザーの場合、セッションを削除
      sign_out current_user
      redirect_to admin_session_path, notice: 'ゲストユーザーアカウントが削除されました。'
      return
    end

    # 通常のログイン処理を実行
    super
  end
  
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  protected

  def after_sign_in_path_for(resource)
    admin_users_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
