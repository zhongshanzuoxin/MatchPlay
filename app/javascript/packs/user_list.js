var userListInterval; // ユーザーリストを定期的に更新するためのインターバルのIDを保持する変数

document.addEventListener('turbolinks:load', function() {
  var userListElement = document.getElementById("user-list"); // ユーザーリスト要素を取得

  if (!userListElement) {
    return; // ユーザーリスト要素が存在しない場合は何もしない
  }

  var groupId = userListElement.getAttribute("data-group-id"); // ユーザーリスト要素からグループIDを取得

  function updateUserList() {
    fetch(`/groups/${groupId}/user_list.json`)
      .then(response => {
        if (response.status === 404) {
          window.location.href = '/'; // ページが見つからない場合はトップページにリダイレクト
          return;
        }
        if (!response.ok) {
          throw new Error('ネットワークの応答が正常でありません。'); // ネットワークエラーの場合はエラーメッセージを投げる
        }
        return response.json();
      })
      .then(data => {
        var userListHTML = data.user_list.map(function(user) {
          return `<li class='list-group-item'><a href='${user.path}'>${user.name}</a></li>`;
        }).join('');
        userListElement.innerHTML = userListHTML; // ユーザーリストを更新
      })
      .catch(error => {
        console.error('問題が発生しました:', error); // エラーメッセージをコンソールに出力
      });
  }

  if (userListInterval) {
    clearInterval(userListInterval); // 既存のインターバルをクリア
  }

  userListInterval = setInterval(updateUserList, 5000); // ユーザーリストを定期的に更新するインターバルを設定
});

document.addEventListener('turbolinks:before-cache', function() {
  if (userListInterval) {
    clearInterval(userListInterval); // キャッシュする前にインターバルをクリア
  }
});
