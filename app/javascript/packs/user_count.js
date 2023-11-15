// ユーザーカウント更新用のインターバルIDを保持する変数
var userCountInterval;

// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function() {
  function updateUserCount() {
    var userCountElements = document.getElementsByClassName("user-count");

    Array.from(userCountElements).forEach(function(userCountElement) {
      var groupId = userCountElement.getAttribute("data-group-id");
      var displayType = userCountElement.getAttribute("data-display-type");
      var xhr = new XMLHttpRequest();
      xhr.open("GET", `/groups/${groupId}/user_count.json`, true);
      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
          var data = JSON.parse(xhr.responseText);
          if (displayType === 'simple') {
            userCountElement.textContent = `参加ユーザー(${data.user_count})`;
          } else if (displayType === 'detailed') {
            userCountElement.textContent = `参加ユーザー ( ${data.user_count} / ${data.max_users} )`;
          }
        }
      };
      xhr.send();
    });
  }

  if (userCountInterval) {
    clearInterval(userCountInterval);
  }

  userCountInterval = setInterval(updateUserCount, 5000);
});

document.addEventListener('turbolinks:before-cache', function() {
  if (userCountInterval) {
    clearInterval(userCountInterval);
  }
});

