// 通知のフェードアウト処理
document.addEventListener('turbolinks:load', () => {
  const notifications = document.querySelectorAll('.notification');
  notifications.forEach((notification) => {
    setTimeout(() => {
      notification.style.display = 'none';
    }, 5000); // 通知を5秒後にフェードアウト
  });
});
