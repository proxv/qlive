$(document).ready(function() {
  module("test-ajax-creation.js");

  asyncTest("create new todo item", 2, function() {
    waitFor('items to load', function() {
      return $('#todo-list li').length > 3;
    }).then(function() {
        var startCount = $('#todo-list li').length;
        ok($('#todo-list li').length >= 4, "should start with at least 4 items");
        var input = $('#new-todo');
        var content = 'Water the dog again';
        input.val(content).trigger(jQuery.Event('keypress', { keyCode: 13 } ));
        equal($('#todo-list li').length, startCount + 1, "should add new item to the list");
        start();
      });
  });
});

