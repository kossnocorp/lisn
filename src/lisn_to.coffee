Lisn = window?.Lisn or require('./lisn.coffee')

# Returns uniq id. Backbone.js do the same thing, but uses "l" as prefix.
# Lisn.js uses "__l" to prevent conficts.
getUniqId = ->
  "__l#{listenersCount++}"

listenersCount = 0

Lisn.listenTo = (object, event, callback) ->
  @setListener(object)
  object.on(event, callback, @)

Lisn.stopListening = (object, event, callback) ->
  return unless @listeners()

  for listener in @listenersFor(object)
    listener.off(event, callback, @)

Lisn.listeners = ->
  @__listeners

Lisn.setListener = (object) ->
  @__listeners ?= {}
  @__listeners[@listenerIdFor(object)] = object

Lisn.listenerIdFor = (object) ->
  object._listenerId || (object._listenerId = getUniqId())
Lisn.listenersFor = (object) ->
  if object?
    [object]
  else
    listener for id, listener of @listeners()
