# Lisn.js - zero-dependency Backbone.js Events implementation

Extend your object with `Lisn` to give it ability to bind and trigger custom events.

## How to extend your object with Lisn?

Vanilla JavaScript:

``` js
for (var property in Lisn) {
  yourObject[property] = Lisn[property];
}
```

CoffeeScript:

``` coffeescript
yourObject[property] = fn for property, fn of Lisn
```

Underscore.js:

``` js
_.extend(yourObject, Lisn);
```

Sugar.js:

``` js
Object.merge(yourObject, Lisn);
```

Easy, right?

## Basic example

```js
yourObject.on('bat-signal', function () {
  alert('(>v^v<)');
});

yourObject.trigger('bat-signal');
```

Try to guess what is result of this snippet? Yes, right. In your door will knock Batman.

## API

    Lisn = {}

### .eventSplitter

RegExp for split events.

    Lisn.eventSplitter = /\s/

### .on(event, callback, [context])

Alias: `bind`.

    Lisn.on = (events, callback, context) ->
      @_events ?= {}

      for event in events.split(@eventSplitter)
        (@_events[event] ?= []).push { callback, context }

    Lisn.bind = Lisn.on

### .off([event], [callback], [context])

Alias: `unbind`.

Returns true if callback obj is match to passed callback and context.

    callbackIsMatch = (obj, callback, context) ->
      ( callback is undefined or
        (obj.callback._fn and obj.callback._fn is callback) or
        obj.callback is callback
      ) and
      (context is undefined or obj.context is context)

Returns array of matched callback objects.

    matchedCallbacks = (callbacks, callback, context) ->
      for obj in callbacks
        obj if callbackIsMatch(obj, callback, context)

    Lisn.off = (events, callback, context) ->
      for event in events.split(@eventSplitter)
        callbacks = @_events[event]

        for obj in matchedCallbacks(callbacks, callback, context)
          if (index = callbacks.indexOf(obj)) isnt -1
            callbacks.splice(index, 1)

    Lisn.unbind = Lisn.off

### .trigger(event, [*args])

    Lisn.trigger = (event, args...) ->
      return unless @_events

      objs = []

      for eventName in [event, 'all']
        if callbacks = @_events[eventName]
          objs.push(callbackObj) for callbackObj in callbacks

      obj.callback.apply(obj.context, args) for obj in objs

### .once(event, callback, [context])

    Lisn.once = (events, callback, context) ->
      self = @
      onceCallback = ->
        self.off(events, onceCallback)
        callback.apply(@, arguments)

      onceCallback._fn = callback
      @on(events, onceCallback, context)

### .listenTo(other, event, callback)

    Lisn.listenTo = (other, event, callback) ->
      other.on(event, callback, @)

### .stopListening([other], [event], [callback])

    Lisn.stopListening = (other, event, callback) ->

### .listenToOnce(other, event, callback)

Export Lisn to global scope:

    if window?
      window.Lisn = Lisn
    else
      module.exports = Lisn
