// ユーザーカウント更新用のインターバルIDを保持する変数
var userCountInterval;

// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function() {
  // ユーザーカウントを更新する関数
  function updateUserCount() {
    var userCountElements = document.getElementsByClassName("user-count");

    Array.from(userCountElements).forEach(function(userCountElement) {
      var groupId = userCountElement.getAttribute("data-group-id");
      var xhr = new XMLHttpRequest();
      xhr.open("GET", `/groups/${groupId}/user_count.json`, true);
      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
          var data = JSON.parse(xhr.responseText);
          userCountElement.textContent = `参加ユーザー(${data.user_count}/${data.max_users})`;
        }
      };
      xhr.send();
    });
  }

  // 既存のインターバルをクリア（存在する場合）
  if (userCountInterval) {
    clearInterval(userCountInterval);
  }

  // 5秒ごとにユーザーカウントを更新
  userCountInterval = setInterval(updateUserCount, 5000);
});

// turbolinks:before-cacheイベントリスナーを追加
document.addEventListener('turbolinks:before-cache', function() {
  // ユーザーカウント更新のインターバルをクリア
  if (userCountInterval) {
    clearInterval(userCountInterval);
  }
});
