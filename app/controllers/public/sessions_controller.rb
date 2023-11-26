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
      # ゲストユーザーが参加しているグループを取得
      groups = Group.where(id: current_user.group_users.pluck(:group_id))

      # グループから退出し、通知を送信
      groups.each do |group|
        group.users.delete(current_user)
        notification_message = "#{current_user.name}さんがグループから退出しました。"
        Notification.create(user: group.owner, content: notification_message)
      end

      # ユーザーアカウントを削除
      current_user.destroy
      redirect_to root_path, notice: 'ゲストユーザーのアカウントが削除されました。'
      return
    else
      # ユーザーが所有するグループを取得して削除
      owned_groups = current_user.owned_groups
      if owned_groups.any?
        owned_groups.destroy_all
      end

      # ユーザーが参加しているグループを取得して退出
      group_users = current_user.group_users
      if group_users.any?
        group_users.each do |group_user|
          group_user.destroy
        end
      end
    end

    # Deviseのデフォルトのログアウト処理を実行
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
end

