<!doctype html>
<html lang="en">

<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" charset="UTF-8">

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
  integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>

<body>

  <div class="container" id="response-area" style="margin-top: 15px">
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
    <#-- <input name="${_csrf.parameterName}" value="${_csrf.token}" type="hidden"> -->
    <input type="text" id="text" placeholder="Write a message..." />
    <input type="text" id="to" placeholder="Write to..." />
    <button id="sendMessage" onclick="sendMessage();">Send</button>
  </div>

  <script src="/static/js/sock.js"></script>
  <script src="/static/js/stomp.js"></script>
  <script type="text/javascript">

  var stompClient = Stomp.over(new SockJS('/room'));
  var username = "fuck";

  stompClient.connect({}, function (frame) {
      stompClient.subscribe('/user/queue/private', function (msgOut) {
      showMessageOutput(JSON.parse(msgOut.body));
    });
    username = frame.headers['user-name'];
});

    function sendMessage() {
      var text = document.getElementById('text').value;
      var to = document.getElementById('to').value;
      var from = username;
      var response = document.getElementById('response-area');
      var p = document.createElement('p');
      p.setAttribute('id', 'message-from');
      p.setAttribute('align', 'right');
      p.setAttribute('class', 'message-from');
      p.appendChild(document.createTextNode(text));
      response.appendChild(p);
      stompClient.send("/app/room", {},
        JSON.stringify({
          'from': from,
          'to': to,
          'text': text,
          'date': null,
        }));
    }

    // function showMessageOutput(msgOut) {
    //   var response = document.getElementById('response-area');
    //   var p = document.createElement('p');
    //   p.style.wordWrap = 'break-word';
    //   p.appendChild(document.createTextNode(msgOut.text + " (" + msgOut.date + ")"));
    //   response.appendChild(p);
    // }



    function showMessageOutput(msgOut) {
      console.log(msgOut.text);
    }

  </script>

  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</body>

</html>
