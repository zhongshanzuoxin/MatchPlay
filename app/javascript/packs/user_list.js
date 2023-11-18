var userListInterval;

document.addEventListener('turbolinks:load', function() {
  var userListElement = document.getElementById("user-list");

  if (!userListElement) {
    return;
  }

  var groupId = userListElement.getAttribute("data-group-id");

  function updateUserList() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", `/groups/${groupId}/user_list.json`, true);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status === 404) {
          window.location.href = '/';
        } else if (xhr.status === 200) {
          var data = JSON.parse(xhr.responseText);
          var userListHTML = data.user_list.map(function(user) {
            return "<li class='list-group-item'><a href='" + user.path + "'>" + user.name + "</a></li>";
          }).join('');
          userListElement.innerHTML = userListHTML;
        }
      }
    };
    xhr.send();
  }

  if (userListInterval) {
    clearInterval(userListInterval);
  }

  userListInterval = setInterval(updateUserList, 5000);
});

document.addEventListener('turbolinks:before-cache', function() {
  if (userListInterval) {
    clearInterval(userListInterval);
  }
});
