$(document).ready(function{} {
  var host = window.location.host;
  var path = window.location.pathname;
  var ws = WebSocket.new("ws://"+host+pathname);

  ws.onmessage(function(message) {
    // eval the js that comes in. huge security risk! :(
    // should mostly consist of adding/removing comments
    eval(message);
  });
})
