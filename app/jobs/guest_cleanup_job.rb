class GuestCleanupJob < ApplicationJob
  queue_as :default
  # 1時間でゲストのデータを削除
  def perform(*args)
    
    before_count = User.where(guest: true).count
    User.where('created_at <= ? AND guest = ?', 1.hour.ago, true).destroy_all
    after_count = User.where(guest: true).count

    Rails.logger.info "GuestCleanupJob: Deleted #{before_count - after_count} guest users."
  end
end
