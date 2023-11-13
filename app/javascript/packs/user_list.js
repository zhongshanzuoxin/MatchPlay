// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function() {
  // ユーザーリストを更新する関数
  function updateUserList() {
    // "user-list" IDを持つ要素を取得
    var userListElement = document.getElementById("user-list");

    // userListElementが存在しない場合は処理を中断
    if (!userListElement) {
      return;
    }

    // グループIDをdata属性から取得
    var groupId = userListElement.getAttribute("data-group-id");

    var xhr = new XMLHttpRequest();

    // グループのユーザーリストを取得するためのリクエストを作成
    xhr.open("GET", `/groups/${groupId}/user_list.json`, true);

    // リクエストの状態が変化した際の処理
    xhr.onreadystatechange = function () {
      // リクエストが完了し、成功した場合
      if (xhr.readyState === 4 && xhr.status === 200) {
        // レスポンスからデータを取得
        var data = JSON.parse(xhr.responseText);

        // ユーザーリストを表現するHTML文字列を生成
        var userListHTML = "";
        for (var i = 0; i < data.user_list.length; i++) {
          userListHTML += "<li class='list-group-item'><a href='" + data.user_list[i].path + "'>" + data.user_list[i].name + "</a></li>";
        }

        // 生成したHTMLをDOMにセット
        userListElement.innerHTML = userListHTML;
      }
    };

    // リクエスト送信
    xhr.send();
  }

  // 5秒ごとにユーザーリストを更新
  setInterval(updateUserList, 5000);
});
