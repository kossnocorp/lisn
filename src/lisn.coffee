EVENTS_SPLITTER = /\s/

Lisn =

  on: (events, fn, context) ->
    for event in @_splittedEvents(events)
      @_addCallback(event, fn, context)

  once: (events, fn, context) ->
    self = @
    onceCallback = ->
      self.off(events, onceCallback)
      fn.apply(@, arguments)

    onceCallback.__originFn = fn
    @on(events, onceCallback, context)

  off: (events, fn, context) ->
    if events?
      for event in @_splittedEvents(events)
        @_removeCallback(event, fn, context)
    else
      @_removeCallbacksFromContext(context)

  trigger: (events, args...) ->
    objs = []

    for event in @_splittedEvents(events)
      if callbacks = @_callbacksFor(event)
        for obj in callbacks
          objs.push(obj)

    @_triggerCallbacks(objs, args)
    @_triggerAllEvents(args)

  _addCallback: (event, fn, context) ->
    callbacks = @_callbacksFor(event)
    callbacks.push(@_buildCallback(fn, context))

  _removeCallback: (event, fn, context) ->
    callbacks = @_callbacksFor(event)

    for callback in @_filterCallbacks(callbacks, fn, context)
      @_removeCallbackFrom(callbacks, callback)

  _removeCallbacksFromContext: (context) ->
    for event, callbacks of @_events()
      for callback in @_filterCallbacks(callbacks, undefined, context)
        @_removeCallbackFrom(callbacks, callback)

  _removeCallbackFrom: (callbacks, callback) ->
    index = callbacks.indexOf(callback)
    callbackExists = index isnt -1
    callbacks.splice(index, 1) if callbackExists

  _triggerAllEvents: (args) ->
    @_triggerCallbacks(@_callbacksFor('all'), args)

  _triggerCallbacks: (callbacks, args) ->
    for callback in callbacks
      callback.fn.apply(callback.context, args)

  _callbacksFor: (event) ->
    events = @_events()
    events[event] ||= []

  _events: ->
    @__events ||= {}

  _filterCallbacks: (callbacks, fn, context) ->
    for callback in callbacks
      callback if @_callbackIsMatch(callback, fn, context)

  _callbackIsMatch: (callback, fn, context) ->
    fnEqualsOrigin = callback.fn.__originFn and callback.fn.__originFn is fn
    fnEquals = fnEqualsOrigin or callback.fn is fn
    fnFits = not fn? or fnEquals

    contextEquals = callback.context is context
    contextFits = not context? or contextEquals

    fnFits and contextFits

  _buildCallback: (fn, context) ->
    {fn, context}

  _splittedEvents: (events) ->
    events?.split(EVENTS_SPLITTER) || []

Lisn.bind = Lisn.on
Lisn.unbind = Lisn.off

if window?
  window.Lisn = Lisn
else
  module.exports = Lisn
