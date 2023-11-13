// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function () {
  // "group-data" IDを持つ要素を取得
  var groupElement = document.getElementById("group-data");
  
  // groupElementが存在する場合のみ処理を実行
  if (groupElement) {
    // groupElementからdata-group-id属性を取得してグループIDを取得
    var group_id = groupElement.getAttribute("data-group-id");

    // メッセージを更新する関数
    var updateMessages = function () {
      // "messages" IDを持つ要素を取得
      var messagesContainer = document.getElementById("messages");

      // messagesContainerが存在する場合のみ処理を実行
      if (messagesContainer) {
        // fetch APIを使用してサーバーからメッセージを取得
        fetch('/groups/' + group_id + '/messages')
          .then(response => {
            // レスポンスがOKでない場合はエラーを投げる
            if (!response.ok) {
              throw new Error('ネットワークエラー');
            }
            return response.text();
          })
          .then(text => {
            // レスポンステキストをmessagesContainerに設定
            messagesContainer.innerHTML = text;
          })
          .catch(error => {
            // エラーが発生した場合はコンソールにエラーを表示
            console.error('メッセージの取得に失敗しました:', error);
          });
      }
    };

    // 初回のメッセージ更新を実行
    updateMessages();
    // 5秒ごとにメッセージを更新
    setInterval(updateMessages, 5000);

    // フォームのajax:successイベントに対するイベントリスナーを追加
    document.querySelector('form').addEventListener('ajax:success', function (event) {
      // 送信成功後に入力フィールドをクリア
      document.getElementById("myInput").value = '';
    });
  }
});
