document.addEventListener('turbolinks:load', () => {
  const bellIcon = document.querySelector('.fa-bell');
  if (bellIcon) {
    bellIcon.addEventListener('click', () => {
      markNotificationsAsRead();
    });
  }
});

function markNotificationsAsRead() {
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
    if (data.unread_count !== undefined) {
      console.log('Notifications marked as read.');
      updateBadgeCount(data.unread_count);
    } else {
      console.error('Error marking notifications as read.');
    }
  });
}

function updateBadgeCount(unreadCount) {
  const badge = document.querySelector('.badge.bg-danger');
  const unreadCountElement = document.getElementById('unread-count');
  if (badge && unreadCountElement) {
    if (unreadCount > 0) {
      badge.textContent = unreadCount;
      badge.style.display = 'inline-block';
      unreadCountElement.textContent = unreadCount; // 未読の表示を更新
    } else {
      badge.style.display = 'none';
      unreadCountElement.textContent = ''; // 未読の表示をクリア
    }
  }
}

document.addEventListener('turbolinks:load', () => {
  const bellIcon = document.querySelector('.fa-bell');
  const notificationIcon = document.querySelector('#notification-icon'); // このクラス名は実際のものに置き換えてください

  if (bellIcon) {
    bellIcon.addEventListener('click', () => {
      markNotificationsAsRead();
    });
  }

  if (notificationIcon) {
    notificationIcon.addEventListener('click', () => {
      markNotificationsAsRead();
    });
  }
});
