document.addEventListener('turbolinks:load', function() {
  // ゲームタイトル検索フィールド、サジェスト結果、検索フォーム要素の取得
  var gameTitleField = document.getElementById('game_title_field');
  var gameTitleSuggestResults = document.getElementById('game_title_suggest_results');
  var gameTitleSearchForm = document.getElementById('game-title-search-form');

  // 各要素が存在する場合の処理
  if (gameTitleField && gameTitleSuggestResults && gameTitleSearchForm) {
    // ゲームタイトル検索フィールドの入力イベント処理
    gameTitleField.addEventListener('input', function() {
      var gameTitleTerm = gameTitleField.value;
      if (gameTitleTerm.length < 2) {
        gameTitleSuggestResults.innerHTML = '';
        return;
      }
      // サジェストデータの取得と表示
      fetch(`/groups/suggest_game_title?term=${encodeURIComponent(gameTitleTerm)}`)
        .then(response => response.json())
        .then(data => {
          gameTitleSuggestResults.innerHTML = data.map(title => `<a href="#" class="list-group-item list-group-item-action">${title}</a>`).join('');
        })
        .catch(error => console.error('Error:', error));
    });

    // サジェスト結果のクリック処理
    gameTitleSuggestResults.addEventListener('click', function(event) {
      if (event.target.tagName === 'A') {
        gameTitleField.value = event.target.textContent;
        gameTitleSuggestResults.innerHTML = '';
        event.preventDefault();
        gameTitleSearchForm.submit();
      }
    });
  }
});
