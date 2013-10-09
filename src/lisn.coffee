Lisn = {}

Lisn.on = (events, callback, context) ->
  @_events ?= {}

  for event in events.split(@eventSplitter)
    (@_events[event] ?= []).push { callback, context }

Lisn.bind = Lisn.on

callbackIsMatch = (obj, callback, context) ->
  ( callback is undefined or
    (obj.callback._fn and obj.callback._fn is callback) or
    obj.callback is callback
  ) and
  (context is undefined or obj.context is context)

matchedCallbacks = (callbacks, callback, context) ->
  for obj in callbacks
    obj if callbackIsMatch(obj, callback, context)

Lisn.off = (events, callback, context) ->
  if events
    for event in events.split(@eventSplitter)
      callbacks = @_events[event]

      for obj in matchedCallbacks(callbacks, callback, context)
        if (index = callbacks.indexOf(obj)) isnt -1
          callbacks.splice(index, 1)
  else

Lisn.unbind = Lisn.off

Lisn.trigger = (event, args...) ->
  return unless @_events

  objs = []

  for eventName in [event, 'all']
    if callbacks = @_events[eventName]
      objs.push(callbackObj) for callbackObj in callbacks

  obj.callback.apply(obj.context, args) for obj in objs

Lisn.once = (events, callback, context) ->
  self = @
  onceCallback = ->
    self.off(events, onceCallback)
    callback.apply(@, arguments)

  onceCallback._fn = callback
  @on(events, onceCallback, context)

listenersCount = 0

# Returns uniq id. Backbone.js do the same thing, but uses "l" as prefix.
# Lisn.js uses "__l" to prevent conficts.
getUniqId = ->
  "__l#{listenersCount++}"

Lisn.listenTo = (other, event, callback) ->
  @_listeners ?= []

  listenerId = other._listenerId || (other._listenerId = getUniqId())

  @_listeners[listenerId] = other
  other.on(event, callback, @)

Lisn.stopListening = (obj, event, callback) ->
  return unless @_listeners
  listeners = if obj
                [obj]
              else
                listener for id, listener of @_listeners

  for listener in listeners
    listener.off(event, callback, @)

if window?
  window.Lisn = Lisn
else
  module.exports = Lisn
