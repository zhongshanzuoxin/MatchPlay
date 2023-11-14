// ユーザーリスト更新用のインターバルIDを保持する変数
var userListInterval;

// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function() {
  var userListElement = document.getElementById("user-list");

  if (!userListElement) {
    return;
  }

  var groupId = userListElement.getAttribute("data-group-id");

  // ユーザーリストを更新する関数
  function updateUserList() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", `/groups/${groupId}/user_list.json`, true);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        var data = JSON.parse(xhr.responseText);
        var userListHTML = data.user_list.map(function(user) {
          return "<li class='list-group-item'><a href='" + user.path + "'>" + user.name + "</a></li>";
        }).join('');
        userListElement.innerHTML = userListHTML;
      }
    };
    xhr.send();
  }

  // 既存のインターバルをクリア（存在する場合）
  if (userListInterval) {
    clearInterval(userListInterval);
  }

  // 5秒ごとにユーザーリストを更新
  userListInterval = setInterval(updateUserList, 5000);
});

// turbolinks:before-cacheイベントリスナーを追加
document.addEventListener('turbolinks:before-cache', function() {
  // ユーザーリスト更新のインターバルをクリア
  if (userListInterval) {
    clearInterval(userListInterval);
  }
});
