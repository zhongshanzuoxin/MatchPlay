document.addEventListener('turbolinks:load', function () {
  var messageUpdateInterval;
  var groupElement = document.getElementById("group-data");
  var isSubmitting = false; // メッセージ送信中かどうかを示すフラグ
  var messagesContainer = document.getElementById("messages");

  if (groupElement) {
    var group_id = groupElement.getAttribute("data-group-id");

    var updateMessages = function () {
      if (messagesContainer) {
        fetch('/groups/' + group_id + '/messages')
          .then(response => {
            if (!response.ok) {
              throw new Error('ネットワークエラー');
            }
            return response.text();
          })
          .then(text => {
            var parser = new DOMParser();
            var newMessages = parser.parseFromString(text, "text/html");
            var newMessagesContainer = newMessages.getElementById("messages");

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

    updateMessages();
    messageUpdateInterval = setInterval(updateMessages, 5000);
  }

  var form = document.querySelector('form[data-remote="true"]');
  if (form) {
    var submitButton = form.querySelector('[type="submit"]');
    var chatInput = document.getElementById("myInput");

    if (submitButton && chatInput) {
      form.addEventListener('ajax:success', function () {
        chatInput.value = '';
        isSubmitting = false;
        submitButton.disabled = false;
      });

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

  document.addEventListener('turbolinks:before-cache', function () {
    if (messageUpdateInterval) {
      clearInterval(messageUpdateInterval);
    }
  });

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
