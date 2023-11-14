// メッセージ更新用のインターバルIDを保持する変数
var messageUpdateInterval;

document.addEventListener('turbolinks:load', function () {
  var groupElement = document.getElementById("group-data");

  if (groupElement) {
    var group_id = groupElement.getAttribute("data-group-id");
    var messagesContainer = document.getElementById("messages");

    var updateMessages = function () {
      if (messagesContainer) {
        fetch('/groups/' + group_id + '/messages')
          .then(response => {
            if (!response.ok) throw new Error('ネットワークエラー');
            return response.text();
          })
          .then(text => {
            messagesContainer.innerHTML = text;
          })
          .catch(error => {
            console.error('メッセージの取得に失敗しました:', error);
          });
      }
    };

    // 初回のメッセージ更新を実行し、5秒ごとの更新をスケジュール
    updateMessages();
    messageUpdateInterval = setInterval(updateMessages, 5000);
  }

  // チャットフォームの送信成功後に入力フィールドをクリア
  var form = document.querySelector('form[data-remote="true"]');
  if (form) {
    form.addEventListener('ajax:success', function () {
      document.getElementById("myInput").value = '';
    });
  }
});

// ページ遷移時にメッセージ更新のインターバルをクリア
document.addEventListener('turbolinks:before-cache', function () {
  if (messageUpdateInterval) {
    clearInterval(messageUpdateInterval);
  }
});

// フォームの送信に失敗した際のエラーハンドリング
document.addEventListener('ajax:error', function(event) {
  var detail = event.detail;
  var xhr = detail[2]; // XMLHttpRequestオブジェクトを取得
  var response;

  try {
    response = JSON.parse(xhr.responseText);
  } catch (e) {
    console.error('レスポンスの解析中にエラーが発生しました:', e);
    return;
  }

  if (response && response.errors) {
    console.error('エラーが発生しました:', response.errors);
  }
});
