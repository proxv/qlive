window.qlog = function(msg, obj) {
  var domConsole = $('#qlog');
  if (!domConsole.length) {
    domConsole = $('<ol id="qlog">Test Log:</ol>').appendTo($('.qlive-structure'));
  }
  if (console && console.log) {
    console.log(msg, obj || '');
  }
  var li = $('<li>' + msg + '</li>');
  if (obj) {
    li.append('<pre>' + JSON.stringify(obj, null, '  ') + '</pre>');
  }
  li.appendTo(domConsole);
};