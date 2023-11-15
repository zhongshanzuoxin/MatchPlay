# app/controllers/public/notifications_controller.rb
class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_as_read
    current_user.notifications.where(read: false).update_all(read: true)

    unread_count = current_user.notifications.where(read: false).count

    respond_to do |format|
      format.json { render json: { unread_count: unread_count } }
    end
  end
end
