// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function() {
  // ユーザーカウントを更新する関数
  function updateUserCount() {
    // "user-count"クラスを持つ要素を全て取得
    var userCountElements = document.getElementsByClassName("user-count");

    // 各要素に対して処理を行う
    Array.from(userCountElements).forEach(function(userCountElement) {
      // グループIDをdata属性から取得
      var groupId = userCountElement.getAttribute("data-group-id");

      var xhr = new XMLHttpRequest();

      // グループのユーザーカウントを取得するためのリクエストを作成
      xhr.open("GET", `/groups/${groupId}/user_count.json`, true);

      // リクエストの状態が変化した際の処理
      xhr.onreadystatechange = function () {
        // リクエストが完了し、成功した場合
        if (xhr.readyState === 4 && xhr.status === 200) {
          // レスポンスからデータを取得
          var data = JSON.parse(xhr.responseText);

          // 取得したデータでユーザーカウントを更新
          userCountElement.textContent = `参加ユーザー(${data.user_count}/${data.max_users})`;
        }
      };

      // リクエスト送信
      xhr.send();
    });
  }

  // 5秒ごとにユーザーカウントを更新
  setInterval(updateUserCount, 5000);
});
