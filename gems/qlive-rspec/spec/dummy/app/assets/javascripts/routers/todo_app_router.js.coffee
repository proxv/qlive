class BackboneOnRailsTodo.Routers.TodoApp extends Backbone.Router
  routes: 
    '': 'index'
    'colors/:color': 'index'

  initialize: ->
    @todos = new BackboneOnRailsTodo.Collections.Todos()
    @todos.fetch()

  index: (color) ->
    view = new BackboneOnRailsTodo.Views.TodoApp({collection: @todos})
    $('#todo-list').html(view.render().el)
    $('<style>#todo-list li { color: ' + (color || 'green') + ';}</style>').appendTo('body')

