<#import "/header.ftl" as h>
<@h.header>
<style media="screen">
ul {
overflow: auto;
overflow-y: scroll;
}
</style>
  <div class="container" style="margin-top: 15px">
    <ul id="response-area">

    </ul>
    <#if error??>
      <div class="alert alert-danger" role="alert">
        ${error}
      </div>
      <a href="/" class="badge badge-primary">Main page</a>
    <#else>
      <#if messages??>
        <#list messages as message>
          <#if message.from==user.username>
            <p align="right" id="message-from" class="message-from">
              <img src="/img/avatar.png" class="img-thumbnail" style="width:50px">
              ${message.text}
              <p align="right" id="time" class="time-info"><i> ${message.date} </i></p>
              <hr>
          <#else>
              <p align="left" id="message-to" class="message-to">
                <img src="/img/avatar.png" class="img-thumbnail" style="width:50px">
                ${message.text}
                <p align="left" id="time" class="time-info"><i> ${message.date} </i></p>
                <hr>
          </#if>
        </#list>
      </#if>
    </div>
      <div class="container">

    <input type="text" id="text" placeholder="Write a message..." />
    <input type="text" id="to" placeholder="Write to..." />
    <button id="sendMessage" onclick="sendMessage();">Send</button>
    </#if>

  </div>

  <script src="/static/js/sock.js"></script>
  <script src="/static/js/stomp.js"></script>
  <script type="text/javascript">
    var stompClient = Stomp.over(new SockJS('/room'));
    var username = "";
    var messageArea = document.getElementById('response-area');

    stompClient.connect({}, function(frame) {
      stompClient.subscribe('/user/queue/updates', function(msgOut) {
        showMessageOutput(JSON.parse(msgOut.body));
      });
      username = frame.headers['user-name'];
    });

    function sendMessage() {
      var text = document.getElementById('text').value;
      var to = document.getElementById('to').value;
      var from = username;
      var time = new Date();
      var response = document.getElementById('response-area');
      var p = document.createElement('p');
      p.setAttribute('id', 'message-from');
      p.setAttribute('align', 'right');
      p.setAttribute('class', 'message-from');
      p.appendChild(document.createTextNode(text + " (" + time + ")"));
      response.appendChild(p);
      response.appendChild(document.createElement('hr'));
      stompClient.send("/app/room", {},
        JSON.stringify({
          'from': from,
          'to': to,
          'text': text,
          'date': null,
        }));

      messageArea.scrollTop = messageArea.scrollHeight;
    }

    function showMessageOutput(msgOut) {
      // var time = new Date();
      var response = document.getElementById('response-area');
      var p = document.createElement('p');
      p.setAttribute('id', 'message-to');
      p.setAttribute('align', 'left');
      p.setAttribute('class', 'message-to');
      p.style.wordWrap = 'break-word';
      p.appendChild(document.createTextNode(msgOut.text + " (" + msgOut.date + ")"));
      response.appendChild(p);
      response.appendChild(document.createElement('hr'));
      messageArea.scrollTop = messageArea.scrollHeight;
    }
  </script>
  </@h.header>
