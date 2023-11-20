class Notification < ApplicationRecord
  belongs_to :user
  after_create :cleanup_old_notifications

  private

  # 一週間で通知を削除
  def cleanup_old_notifications
    Notification.where('created_at < ?', 1.week.ago).destroy_all
  end
end
