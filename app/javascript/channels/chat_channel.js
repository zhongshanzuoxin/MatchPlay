import consumer from './consumer';

consumer.subscriptions.create({ channel: "ChatChannel", group_id: groupId }, {
  connected() {
    
  },
  
  disconnected() {
    
  },
  
  received(data) {
    $('#messages').append(data['message']);
  },
  
  speak: function(message) {
    return this.perform('speak', { message: message });
  }
});

$(document).on('submit', 'form', function(e) {
  e.preventDefault();
  var message = $('#message').val();
  consumer.subscriptions.chatChannel.speak(message);
  $('#message').val('');
});
 