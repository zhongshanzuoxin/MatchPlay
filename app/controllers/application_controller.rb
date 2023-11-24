class ApplicationController < ActionController::Base
  # すべてのコントローラーアクションの前に実行されるフィルター
  before_action :check_user_active

  private

  # ユーザーのアクティブ状態を確認し、無効な場合の処理を実行するメソッド
  def check_user_active
    # ユーザーがログインしており、かつユーザーが非アクティブである場合
    if user_signed_in? && !current_user.is_active?
      sign_out current_user
      redirect_to new_user_session_path, alert: 'アカウントは無効です。'
    end
  end
end
