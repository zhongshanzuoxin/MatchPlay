document.addEventListener('turbolinks:load', function() {
  var logoutLink = document.getElementById('logout-link');

  if (logoutLink) {
    logoutLink.addEventListener('click', function(event) {
      var isPartOfGroup = this.dataset.partOfGroup === 'true';

      // ユーザーがグループに参加または所有している場合のみ確認ダイアログを表示
      if (isPartOfGroup) {
        var confirmation = confirm('本当にログアウトしますか？グループを所有している場合は削除され、参加しているグループからは退出されます。');
        if (!confirmation) {
          event.preventDefault();
        }
      }
    });
  }
});
