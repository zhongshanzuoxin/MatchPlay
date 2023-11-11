document.addEventListener('turbolinks:load', function() {
  function updateUserList() {
    var userListElement = document.getElementById("user-list");

    if (!userListElement) {
      return; // 要素が存在しない場合、何もしない
    }

    // グループIDの取得
    var groupId = userListElement.getAttribute("data-group-id");

    var xhr = new XMLHttpRequest();

    // URLをテンプレート文字列を使って構築
    xhr.open("GET", `/groups/${groupId}/user_list.json`, true);

    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        var data = JSON.parse(xhr.responseText);

        // ユーザーリストを更新
        var userListHTML = "";

        // data.user_list の各要素に対して適切なHTML文字列を生成
        for (var i = 0; i < data.user_list.length; i++) {
          // リンクを含むHTML文字列を生成
          userListHTML += "<li class='list-group-item'><a href='" + data.user_list[i].path + "'>" + data.user_list[i].name + "</a></li>";
        }

        // userListHTMLをセット
        userListElement.innerHTML = userListHTML;
      }
    };

    xhr.send();
  }

  // 一定の間隔でユーザーリストを更新
  setInterval(updateUserList, 5000); // 例: 5秒ごとに更新
});
