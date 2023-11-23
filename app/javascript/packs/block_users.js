document.addEventListener('turbolinks:load', function() {
  // .block-link クラスを持つすべての要素に対して処理を行う
  document.querySelectorAll('.block-link').forEach(function(link) {
    // ブロックが成功したときの処理
    link.addEventListener('ajax:success', function(event) {
      // イベントの詳細情報を取得
      const detail = event.detail;
      const [data, status, xhr] = detail;

      // ブロック対象のユーザーIDを取得
      const userId = this.dataset.userId;
      // ユーザー要素を取得
      const userElement = document.getElementById('user_' + userId);
      // ユーザー要素が存在する場合、削除する
      if (userElement) {
        userElement.remove();
      }
    });

    // ブロックがエラーしたときの処理
    link.addEventListener('ajax:error', function(event) {
      // エラー詳細情報を取得
      const [xhr, status, error] = event.detail;
      // エラーメッセージを表示
      alert("操作に失敗しました。");
    });
  });
});
