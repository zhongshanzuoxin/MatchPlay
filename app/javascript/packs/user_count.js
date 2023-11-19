var userCountInterval; // ユーザーカウントを定期的に更新するためのインターバルのIDを保持する変数

document.addEventListener('turbolinks:load', function() {
  function updateUserCount() {
    var userCountElements = document.getElementsByClassName("user-count"); // ユーザーカウント要素を取得

    Array.from(userCountElements).forEach(function(userCountElement) {
      var groupId = userCountElement.getAttribute("data-group-id"); // グループIDを取得
      var displayType = userCountElement.getAttribute("data-display-type"); // 表示タイプを取得

      fetch(`/groups/${groupId}/user_count.json`)
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
          if (displayType === 'simple') {
            userCountElement.textContent = `参加ユーザー(${data.user_count})`;
          } else if (displayType === 'detailed') {
            userCountElement.textContent = `参加ユーザー ( ${data.user_count} / ${data.max_users} )`;
          }
        })
        .catch(error => {
          console.error('問題が発生しました:', error); // エラーメッセージをコンソールに出力
        });
    });
  }

  if (userCountInterval) {
    clearInterval(userCountInterval); // 既存のインターバルをクリア
  }

  userCountInterval = setInterval(updateUserCount, 5000); // ユーザーカウントを定期的に更新するインターバルを設定
});

document.addEventListener('turbolinks:before-cache', function() {
  if (userCountInterval) {
    clearInterval(userCountInterval); // キャッシュする前にインターバルをクリア
  }
});
