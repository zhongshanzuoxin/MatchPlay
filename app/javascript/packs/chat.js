document.addEventListener('turbolinks:load', function () {
  var groupElement = document.getElementById("group-data");
  if (groupElement) {
    var group_id = groupElement.getAttribute("data-group-id");

    var updateMessages = function () {
      var messagesContainer = document.getElementById("messages");
      if (messagesContainer) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", '/groups/' + group_id + '/messages', true);

        xhr.onreadystatechange = function () {
          if (xhr.readyState === 4 && xhr.status === 200) {
            messagesContainer.innerHTML = xhr.responseText;
          }
        };

        xhr.send();
      }
    };

    updateMessages();

    setInterval(updateMessages, 5000);

    document.querySelector('form').addEventListener('ajax:success', function (event) {
      document.getElementById("myInput").value = '';
    });
  }
});
