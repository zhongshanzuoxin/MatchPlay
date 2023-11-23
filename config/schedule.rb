# 1時間でゲストユーザー情報を削除するタイマー
every 1.hour do
  runner "GuestCleanupJob.perform_later"
end
