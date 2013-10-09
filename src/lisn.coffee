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

Lisn =

  on: (events, callback, context) ->
    for event in @splittedEvents(events)
      @addCallback(event, callback, context)

  off: (events, callback, context) ->
    for event in @splittedEvents(events)
      eventCallbacks = @callbacksFor(event)

      for obj in matchedCallbacks(eventCallbacks, callback, context)
        index = eventCallbacks.indexOf(obj)
        callbackExists = index isnt -1
        eventCallbacks.splice(index, 1) if callbackExists

  trigger: (events, args...) ->
    objs = []

    for event in @splittedEvents(events)
      if callbacks = @callbacksFor(event)
        for obj in callbacks
          objs.push(obj)

    for obj in objs
      obj.callback.apply(obj.context, args)

    @triggerAllEvent(args)

  once: (events, callback, context) ->
    self = @
    onceCallback = ->
      self.off(events, onceCallback)
      callback.apply(@, arguments)

    onceCallback._fn = callback
    @on(events, onceCallback, context)

  callbacksFor: (event) ->
    @eventsMap ?= {}
    @eventsMap[event] ||= []

  addCallback: (event, callback, context) ->
    @callbacksFor(event).push {callback, context}

  removeCallback: ->

  triggerAllEvent: (args) ->
    @triggerCallbacks(@callbacksFor('all'), args)

  triggerCallbacks: (callbacks, args) ->
    for callback in callbacks
      callback.callback.apply(callback.context, args)

  splittedEvents: (events) ->
    events?.split(@eventSplitter) || []

Lisn.bind = Lisn.on
Lisn.unbind = Lisn.off

if window?
  window.Lisn = Lisn
else
  module.exports = Lisn
