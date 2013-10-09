callbackIsMatch = (obj, callback, context) ->
  ( callback is undefined or
    (obj.callback._fn and obj.callback._fn is callback) or
    obj.callback is callback
  ) and
  (context is undefined or obj.context is context)

matchedCallbacks = (callbacks, callback, context) ->
  for obj in callbacks
    obj if callbackIsMatch(obj, callback, context)

listenersCount = 0

# Returns uniq id. Backbone.js do the same thing, but uses "l" as prefix.
# Lisn.js uses "__l" to prevent conficts.
getUniqId = ->
  "__l#{listenersCount++}"

Lisn =

  eventsMap: {}

  callbacksFor: (event) ->
    @eventsMap[event] ||= []

  addCallbackTo: (event, callback, context) ->
    @callbacksFor(event).push {callback, context}

  splittedEvents: (eventsStr) ->
    eventsStr.split(@eventSplitter)

  on: (eventsStr, callback, context) ->
    for event in @splittedEvents(eventsStr)
      @addCallbackTo(event, callback, context)

  off: (eventsStr, callback, context) ->
    if eventsStr?
      for event in @splittedEvents(eventsStr)
        eventCallbacks = @callbacksFor(event)

        for obj in matchedCallbacks(eventCallbacks, callback, context)
          if (index = eventCallbacks.indexOf(obj)) isnt -1
            eventCallbacks.splice(index, 1)

  trigger: (eventStr, args...) ->
    objs = []

    for event in [eventStr, 'all']
      if callbacks = @callbacksFor(event)
        objs.push(callbackObj) for callbackObj in callbacks

    obj.callback.apply(obj.context, args) for obj in objs

  once: (events, callback, context) ->
    self = @
    onceCallback = ->
      self.off(events, onceCallback)
      callback.apply(@, arguments)

    onceCallback._fn = callback
    @on(events, onceCallback, context)

  listenTo: (other, event, callback) ->
    @_listeners ?= []

    listenerId = other._listenerId || (other._listenerId = getUniqId())

    @_listeners[listenerId] = other
    other.on(event, callback, @)

  stopListening: (obj, event, callback) ->
    return unless @_listeners
    listeners = if obj
                  [obj]
                else
                  listener for id, listener of @_listeners

    for listener in listeners
      listener.off(event, callback, @)

Lisn.bind = Lisn.on
Lisn.unbind = Lisn.off

if window?
  window.Lisn = Lisn
else
  module.exports = Lisn
