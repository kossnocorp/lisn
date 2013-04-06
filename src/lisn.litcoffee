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

### .on(event, callback, [context])

Alias: `bind`.

    Lisn.on = (events, callback, context) ->
      @_events ?= {}
      for event in events.split(/\s/)
        @_events[event] ?= []
        @_events[event].push { callback, context }

    Lisn.bind = Lisn.on

### .off([event], [callback], [context])

Alias: `unbind`.

    Lisn.off = (events, callback, context) ->
      for event in events.split(/\s/g)
        callbacks = @_events[event]
        objs  = for obj in callbacks
                  callbackIsMatch = callback is undefined or
                                    (obj.callback._fn and obj.callback._fn is callback) or
                                    obj.callback is callback

                  if callbackIsMatch and (context is undefined or obj.context is context)
                    obj
                  else
                    undefined

        for obj in objs
          index = callbacks.indexOf(obj)
          callbacks.splice(index, 1) if index isnt -1

    Lisn.unbind = Lisn.off

### .trigger(event, [*args])

    Lisn.trigger = (event, args...) ->
      return unless @_events

      objs = []

      for eventName in [event, 'all']
        if callbacks = @_events[eventName]
          for callbackObj in callbacks
            objs.push callbackObj

      for obj in objs
        if obj.context
          obj.callback.apply(obj.context, args)
        else
          obj.callback(args...)

### .once(event, callback, [context])

    Lisn.once = (events, callback, context) ->
      self = @
      onceCallback = ->
        self.off(events, onceCallback)
        callback.apply(@, arguments)

      onceCallback._fn = callback
      @on(events, onceCallback, context)

### .listenTo(other, event, callback)

### .stopListening([other], [event], [callback])

Export Lisn to global scope:

    if window?
      window.Lisn = Lisn
    else
      module.exports = Lisn
