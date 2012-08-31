window.BackboneOnRailsTodo =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new BackboneOnRailsTodo.Routers.TodoApp
    Backbone.history.start()

$(document).ready ->
  BackboneOnRailsTodo.init()
