$(document).ready(function() {
  module("test-empty-list.js");

  asyncTest("regression test of empty list", 1, function() {
    waitFor('items load', function() {
      return $('#todo-list').length;
    }).then(function() {
        ok($('#create-todo input').length, 'new item input box should render when list is empty');
        start();
      });
  });
});
