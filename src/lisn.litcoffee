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
        @_events[event] = if context
                            (args...) -> callback.apply(context, args)
                          else
                            callback

    Lisn.bind = Lisn.on

### .off([event], [callback], [context])

Alias: `unbind`.

### .trigger(event, [*args])

    Lisn.trigger = (event, args...) ->
      return unless @_events

      @_events[event]?(args...)
      @_events['all']?(args...)

### .once(event, callback, [context])

    Lisn.once = ->

### .listenTo(other, event, callback)

### .stopListening([other], [event], [callback])

Export Lisn to global scope:

    if window?
      window.Lisn = Lisn
    else
      module.exports = Lisn
