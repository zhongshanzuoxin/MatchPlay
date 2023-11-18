class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_as_read
    # 未読通知の数を計算
    unread_count = current_user.notifications.where(read: false).count

    # 未読の通知を既読に変更
    current_user.notifications.where(read: false).update_all(read: true)

    # JSON形式で未読通知数を返す
    respond_to do |format|
      format.json { render json: { unread_count: unread_count } }
    end
  end
end
