(function(root) {

  var socket = root.socket = (root.socket || {});

  socket.setup = function() {

    console.log("Websocket js setup")

    var host = window.location.host;
    var path = window.location.pathname;
    var ws = new WebSocket("ws://"+host+path);

    ws.onmessage = function(message) {
      var response = $.parseJSON(message.data);
      window.discussion[response.functionName](response.params);
    };
  }
})(this)
