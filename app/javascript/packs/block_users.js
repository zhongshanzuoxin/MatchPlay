document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.block-link').forEach(function(link) {
    link.addEventListener('ajax:success', function(event) {
      var userId = this.dataset.userId; // ユーザーIDの取得

      // リクエスト成功時の処理
      var userElement = document.getElementById('user_' + userId);
      if (userElement) {
        userElement.remove(); // ユーザーのリスト項目を削除
      }
    });
  });
});
