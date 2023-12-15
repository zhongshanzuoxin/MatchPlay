// turbolinksのページ読み込み完了時にイベントリスナーを追加
document.addEventListener('turbolinks:load', function () {
  var messageUpdateInterval;
  var groupElement = document.getElementById("group-data");
  var isSubmitting = false; // メッセージ送信中かどうかを示すフラグ
  var messagesContainer = document.getElementById("messages");

  // groupElementが存在する場合の処理
  if (groupElement) {
    var group_id = groupElement.getAttribute("data-group-id");

    // メッセージを定期的に更新する関数
    var updateMessages = function () {
      if (messagesContainer) {
        // サーバーからメッセージを取得
        fetch('/groups/' + group_id + '/messages')
          .then(response => {
            if (!response.ok) {
              throw new Error('ネットワークエラー');
            }
            return response.text();
          })
          .then(text => {
            // 取得したテキストをHTMLとしてパース
            var parser = new DOMParser();
            var newMessages = parser.parseFromString(text, "text/html");
            var newMessagesContainer = newMessages.getElementById("messages");

            // 新しいメッセージを表示
            if (newMessagesContainer) {
              while (newMessagesContainer.firstChild) {
                messagesContainer.appendChild(newMessagesContainer.firstChild);
              }
            }
          })
          .catch(error => {
            console.error('メッセージの取得に失敗しました:', error);
          });
      }
    };

    // 初回のメッセージ更新と、定期的な更新を設定
    updateMessages();
    messageUpdateInterval = setInterval(updateMessages, 5000);
  }

  // フォームが存在する場合の処理
  var form = document.querySelector('form[data-remote="true"]');
  if (form) {
    var submitButton = form.querySelector('[type="submit"]');
    var chatInput = document.getElementById("myInput");

    if (submitButton && chatInput) {
      // フォームが正常に送信された場合の処理
      form.addEventListener('ajax:success', function () {
        chatInput.value = '';
        isSubmitting = false;
        submitButton.disabled = false;
      });

      // チャット入力欄でEnterキーが押された場合の処理
      chatInput.addEventListener("keydown", function(event) {
        if (event.key === "Enter" && !event.isComposing) {
          event.preventDefault();
          if (chatInput.value.trim() !== "" && !isSubmitting) {
            isSubmitting = true;
            form.submit();
          }
        }
      });
    }
  }

  // turbolinksのページ遷移前にインターバルをクリア
  document.addEventListener('turbolinks:before-cache', function () {
    if (messageUpdateInterval) {
      clearInterval(messageUpdateInterval);
    }
  });

  // Ajaxリクエストでエラーが発生した場合の処理
  document.addEventListener('ajax:error', function(event) {
    var detail = event.detail;
    var xhr = detail[2];
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
    isSubmitting = false;
    if (submitButton) {
      submitButton.disabled = false;
    }
  });
});
