<!doctype html>
<html lang="en">

<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <title>Websocket chat</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" charset="UTF-8">
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  <link rel="stylesheet" href="../static/css/style.css">
</head>

<body>

  <#if error??>
    <div class="alert alert-danger" role="alert">
      ${error}
    </div>
    <a href="/" class="badge badge-primary">Main page</a>
  <#else>
  <div id="chat-page" class="">
    <div class="chat-container">
      <div class="chat-header">
        <h2>Spring WebSocket Chat Demo</h2>
      </div>
      <ul id="messageArea">
      </ul>
      <form id="messageForm" name="messageForm">
        <div class="form-group">
          <div class="input-group clearfix">
            <input type="text" id="message" placeholder="Write a message..." autocomplete="off" class="form-control" />
            <input type="text" id="to" placeholder="Write destination" autocomplete="off" class="form-control" />
            <button type="submit" class="primary">Send</button>
          </div>
        </div>
      </form>
    </div>
  </div>
  </#if>

  <script src="/static/js/sock.js"></script>
  <script src="/static/js/stomp.js"></script>
  <script type="text/javascript">

  'use strict';
var usernamePage = document.querySelector('#username-page');
var chatPage = document.querySelector('#chat-page');
// var usernameForm = document.querySelector('#usernameForm');
var messageForm = document.querySelector('#messageForm');
var messageInput = document.querySelector('#message');
var messageArea = document.querySelector('#messageArea');
var to = document.querySelector('#to');
var stompClient = null;
var username = null;
var colors = [
    '#2196F3', '#32c787', '#00BCD4', '#ff5652',
    '#ffc107', '#ff85af', '#FF9800', '#39bbb0'
];
function connect(event) {
        stompClient = Stomp.over(new SockJS('/room'));
        stompClient.connect({}, onConnected, onError);
        username = frame.headers['user-name'];
    event.preventDefault();
}

function onConnected() {
    // Subscribe to the Public Topic
    stompClient.subscribe('/user/queue/updates', onMessageReceived);
    // Tell your username to the server

}

function sendMessage(event) {
    var messageContent = messageInput.value.trim();
    if(messageContent && stompClient) {
        var chatMessage = {
            from: username,
            to: to,
            text: messageContent
        };
        stompClient.send("/app/room", {}, JSON.stringify(chatMessage));
        messageInput.value = '';
    }
    event.preventDefault();
}

function onMessageReceived(payload) {
    var message = JSON.parse(payload.body);
    var messageElement = document.createElement('li');
    messageElement.classList.add('chat-message');
    var avatarElement = document.createElement('i');
    var avatarText = document.createTextNode(message.from);
    avatarElement.appendChild(avatarText);
    avatarElement.style['background-color'] = getAvatarColor(message.from);
    messageElement.appendChild(avatarElement);
    var usernameElement = document.createElement('span');
    var usernameText = document.createTextNode(message.from);
    usernameElement.appendChild(usernameText);
    messageElement.appendChild(usernameElement);
    var textElement = document.createElement('p');
    var messageText = document.createTextNode(message.text);
    textElement.appendChild(messageText);
    messageElement.appendChild(textElement);
    messageArea.appendChild(messageElement);
    messageArea.scrollTop = messageArea.scrollHeight;
}

function getAvatarColor(messageSender) {
    var hash = 0;
    for (var i = 0; i < messageSender.length; i++) {
        hash = 31 * hash + messageSender.charCodeAt(i);
    }
    var index = Math.abs(hash % colors.length);
    return colors[index];
}

// usernameForm.addEventListener('submit', connect, true)
messageForm.addEventListener('submit', sendMessage, true)

  </script>

</body>

</html>
</body>

</html>
