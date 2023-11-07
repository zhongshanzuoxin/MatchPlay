import consumer from "./consumer"

const appRoom = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const messages = document.getElementById('messages');
    messages.insertAdjacentHTML('beforeend', data['message']);
    // Called when there's incoming data on the websocket for this channel
  },

  speak: function(message) {
    return this.perform('speak', {message: message});
  }
});

window.addEventListener("keypress", function(e) {
  console.log("キーが押されました。キーコード: " + e.keyCode);
  if (e.keyCode === 13) {
    console.log("Enterキーが押されました。");
    appRoom.speak(e.target.value);
    e.target.value = '';
    e.preventDefault();
  }
})