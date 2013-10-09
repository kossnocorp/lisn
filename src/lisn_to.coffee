Lisn = window?.Lisn or require('./lisn.coffee')

listenersCount = 0

LisnTo =

  listenTo: (object, event, fn) ->
    @_setListener(object)
    object.on(event, fn, @)

  listenToOnce: (object, event, fn) ->
    @_setListener(object)
    object.once(event, fn, @)

  stopListening: (object, events, fn) ->
    for listener in @_listenersFor(object)
      listener.object.off(events, fn, @)

  _listeners: ->
    @__listeners

  _setListener: (object) ->
    @__listeners ?= {}
    @__listeners[@_listenerIdFor(object)] = {object}

  _listenerIdFor: (object) ->
    object._listenerId || (object._listenerId = @_getUniqListenerId())

  _listenersFor: (object) ->
    if object?
      [{object}]
    else
      listener for id, listener of @_listeners()

  # Returns uniq id. Backbone.js do the same thing, but uses "l" as prefix.
  # Lisn.js uses "__l" to prevent conficts.
  _getUniqListenerId: ->
    "__l#{listenersCount++}"

Lisn[key] = val for key, val of LisnTo
