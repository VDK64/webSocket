<#import "/header.ftl" as h>
  <@h.header>
    <link rel="stylesheet" href="../static/css/style.css">  
    <div class="container" style="margin-top: 15px">
      <#if error??>
        <div class="alert alert-danger" role="alert">
          ${error}
        </div>
        <a href="/" class="badge badge-primary">Main page</a>
      <#else>
        <a href="/" class="badge badge-primary">Main page(exit)</a>
    </div>
    <div id="chat-page" class="">
      <div class="chat-container">
        <div class="chat-header">
          <h2>Spring WebSocket Chat Demo</h2>
        </div>
        <ul id="messageArea">
        </ul>
        <div class="form-group">
          <div class="input-group clearfix">
            <input type="text" id="message" placeholder="Write a message..." autocomplete="off" class="form-control" />
            <input type="text" id="to" placeholder="Write destination" autocomplete="off" class="form-control" />
            <button onclick="sendMessage();" class="primary">Send</button>
          </div>
        </div>
      </div>
    </div>
      </#if>

    <script src="/static/js/sock.js"></script>
    <script src="/static/js/stomp.js"></script>
    <script type="text/javascript">
      'use strict';
      var usernamePage = document.querySelector('#username-page');
      var chatPage = document.querySelector('#chat-page');
      var messageForm = document.querySelector('#messageForm');
      var messageInput = document.querySelector('#message');
      var messageArea = document.querySelector('#messageArea');
      var stompClient = Stomp.over(new SockJS('/room'));
      var username = null;
      var colors = [
        '#2196F3', '#32c787', '#00BCD4', '#ff5652',
        '#ffc107', '#ff85af', '#FF9800', '#39bbb0'
      ];

      stompClient.connect({}, function(frame) {
        stompClient.subscribe('/user/queue/updates', function(msgOut) {
          onMessageReceived(msgOut);
        });
        username = frame.headers['user-name'];
      });

      function sendMessage(event) {
        var messageContent = messageInput.value.trim();
        var to = document.getElementById('to').value;
        if (messageContent && stompClient) {
          var chatMessage = {
            from: username,
            to: to,
            text: messageContent
          };
          stompClient.send("/app/room", {}, JSON.stringify(chatMessage));
          messageInput.value = '';
          var messageElement = document.createElement('li');
          messageElement.classList.add('chat-message');
          var avatarElement = document.createElement('i');
          var image = document.createElement('img');
          image.setAttribute('src', '/img/avatar.png');
          image.setAttribute('class', 'img-thumbnail');
          image.setAttribute('style', 'width:50px');
          image.setAttribute('border', '0');
          avatarElement.appendChild(image);
          messageElement.appendChild(avatarElement);
          var usernameElement = document.createElement('span');
          var usernameText = document.createTextNode(username);
          usernameElement.appendChild(usernameText);
          messageElement.appendChild(usernameElement);
          var textElement = document.createElement('p');
          var messageText = document.createTextNode(messageContent);
          textElement.appendChild(messageText);
          messageElement.appendChild(textElement);
          messageArea.appendChild(messageElement);
          messageArea.scrollTop = messageArea.scrollHeight;
        }
      }

      function onMessageReceived(payload) {
        var message = JSON.parse(payload.body);
        var messageElement = document.createElement('li');
        messageElement.classList.add('chat-message');
        var avatarElement = document.createElement('i');
        var image = document.createElement('img');
        image.setAttribute('src', '/img/avatar.png');
        image.setAttribute('class', 'img-thumbnail');
        image.setAttribute('style', 'width:50px');
        image.setAttribute('border', '0');
        avatarElement.appendChild(image);
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
    </script>

  </@h.header>
