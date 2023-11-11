document.addEventListener('turbolinks:load', function() {
  function updateUserCount() {
    var userCountElements = document.getElementsByClassName("user-count");

    Array.from(userCountElements).forEach(function(userCountElement) {
      // グループIDの取得
      var groupId = userCountElement.getAttribute("data-group-id");

      var xhr = new XMLHttpRequest();

      // URLをテンプレート文字列を使って構築
      xhr.open("GET", `/groups/${groupId}/user_count.json`, true);

      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
          var data = JSON.parse(xhr.responseText);

          // ユーザーカウントと最大ユーザー数を更新
          userCountElement.textContent = `参加ユーザー(${data.user_count}/${data.max_users})`;
        }
      };

      xhr.send();
    });
  }

  // 一定の間隔でユーザーカウントを更新
  setInterval(updateUserCount, 5000); // 例: 5秒ごとに更新
});
