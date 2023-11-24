document.addEventListener('turbolinks:load', function() {
  // ユーザー名検索フィールドとサジェスト結果要素の取得
  var userNameField = document.getElementById('user-name-field');
  var userNameSuggestResults = document.getElementById('user-name-suggest-results');

  // メッセージ検索フィールドとサジェスト結果要素の取得
  var messageField = document.getElementById('message-search-field');
  var messageSuggestResults = document.getElementById('message-suggest-results');

  // ユーザー名検索フォームの処理
  if (userNameField) {
    userNameField.addEventListener('input', function() {
      var userNameTerm = userNameField.value;
      if (userNameTerm.length < 2) {
        userNameSuggestResults.innerHTML = '';
        return;
      }
      // サジェストデータの取得と表示
      fetch(`/admin/users/suggest_users?term=${encodeURIComponent(userNameTerm)}`)
        .then(response => response.json())
        .then(data => {
          userNameSuggestResults.innerHTML = data.map(name => `<a href="#" class="list-group-item list-group-item-action">${name}</a>`).join('');
        });
    });

    // サジェスト結果のクリック処理
    userNameSuggestResults.addEventListener('click', function(event) {
      if (event.target.tagName === 'A') {
        userNameField.value = event.target.textContent;
        userNameSuggestResults.innerHTML = '';
        event.preventDefault();
        document.getElementById('search-form').submit();  // フォームの送信
      }
    });
  }

  // メッセージ検索フォームの処理
  if (messageField) {
    messageField.addEventListener('input', function() {
      var messageTerm = messageField.value;
      if (messageTerm.length < 2) {
        messageSuggestResults.innerHTML = '';
        return;
      }
      // サジェストデータの取得と表示
      fetch(`/admin/users/suggest_messages?term=${encodeURIComponent(messageTerm)}`)
        .then(response => response.json())
        .then(data => {
          messageSuggestResults.innerHTML = data.map(content => `<a href="#" class="list-group-item list-group-item-action">${content}</a>`).join('');
        });
    });

    // サジェスト結果のクリック処理
    messageSuggestResults.addEventListener('click', function(event) {
      if (event.target.tagName === 'A') {
        messageField.value = event.target.textContent;
        messageSuggestResults.innerHTML = '';
        event.preventDefault();
        document.getElementById('message-search-form').submit(); // フォームの送信
      }
    });
  }
});
