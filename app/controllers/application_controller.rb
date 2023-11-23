class ApplicationController < ActionController::Base
  before_action :check_user_active
  before_action :check_guest_user

  private

  # ユーザーのアクティブ状態を確認し、無効な場合の処理を実行するメソッド
  def check_user_active
    return unless user_signed_in?
    
    if !current_user.is_active?
      perform_logout('アカウントは無効になりました。')
    end
  end
  
  # ゲストユーザーの期限が切れた際の処理
  def check_guest_user
    return unless user_signed_in? && current_user.guest?

    if !User.exists?(current_user.id)
      perform_logout('ゲストセッションは期限切れです。')
    end
  rescue ActiveRecord::RecordNotFound
    # ユーザーレコードが見つからない場合のエラーハンドリング
    perform_logout('アカウントの情報が見つかりません。')
  end

  # ユーザーのログアウトとリダイレクトを実行するヘルパーメソッド
  def perform_logout(message)
    sign_out current_user
    redirect_to new_user_session_path, alert: message
  end
end
