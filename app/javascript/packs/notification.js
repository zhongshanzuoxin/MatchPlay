// ページが読み込まれたときに実行されるコード
document.addEventListener('turbolinks:load', () => {
  // ベルアイコンと通知アイコンを取得
  const bellIcon = document.querySelector('.fa-bell');
  const notificationIcon = document.querySelector('#notification-icon'); 

  // ベルアイコンが存在する場合、クリックイベントを設定
  if (bellIcon) {
    bellIcon.addEventListener('click', () => {
      markNotificationsAsRead();
    });
  }

  // 通知アイコンが存在する場合、クリックイベントを設定
  if (notificationIcon) {
    notificationIcon.addEventListener('click', () => {
      markNotificationsAsRead();
    });
  }
});

// 通知を既読にする関数
function markNotificationsAsRead() {
  // サーバーに通知の既読をマークするリクエストを送信
  fetch('/notifications/mark_as_read', {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    credentials: 'include'
  })
  .then(response => response.json())
  .then(data => {
    // レスポンスから未読の通知数を取得し、バッジを更新
    if (data.unread_count !== undefined) {
      console.log('Notifications marked as read.');
      updateBadgeCount(data.unread_count);
    } else {
      console.error('Error marking notifications as read.');
    }
  });
}

// 未読の通知数をバッジとして表示を更新する関数
function updateBadgeCount(unreadCount) {
  const badge = document.querySelector('.badge.bg-danger');
  const unreadCountElement = document.getElementById('unread-count');
  if (badge && unreadCountElement) {
    if (unreadCount > 0) {
      // 未読の数を表示し、バッジを表示
      badge.textContent = unreadCount;
      badge.style.display = 'inline-block';
      unreadCountElement.textContent = unreadCount; // 未読の表示を更新
    } else {
      // 未読がない場合、バッジを非表示にし、表示をクリア
      badge.style.display = 'none';
      unreadCountElement.textContent = ''; // 未読の表示をクリア
    }
  }
}
