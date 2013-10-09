# Lisn.js - zero-dependency Backbone.js Events implementation

[![Build Status](https://secure.travis-ci.org/kossnocorp/lisn.png?branch=master)](http://travis-ci.org/kossnocorp/lisn)

Reason why I've created clone of Backbone.js Events is that fact what
Backbone.js (1) depends on Underscore.js and (2) it backed in one solid
file. There is no way to reuse Backbone.js components separetly.

Lisn.js created for give power and simplicity of Backbone.js Events to
another libraries and lightweight web pages (e.g mobile or landing).

## Key features

* Lisn.js is fully compatible with original Backbone.js's API,
* it designed to be as light as possible,
* Lisn.js doesn't depends on 3rd-party libraries,
* it works on all modern browsers (IE>=9),
* it written in CoffeeScript but can be used as vanilla JS.

## Description

TODO

## Usage

Extend your object with `Lisn` to give it ability to bind and trigger custom events.

### How to extend your object with Lisn?

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

### Basic example

``` js
yourObject.on('bat-signal', function () {
  alert('(>v^v<)');
});

yourObject.trigger('bat-signal');
```

Try to guess what is result of this snippet? Yes, right. In your door will knock Batman.


## API

### .eventSplitter

RegExp for split events.

    Lisn.eventSplitter = /\s/

### .on(event, callback, [context])

Alias: `bind`.

### .off([event], [callback], [context])

Alias: `unbind`.

Returns true if callback obj is match to passed callback and context.

### .trigger(event, [*args])

### .once(event, callback, [context])

### .stopListening([other], [event], [callback])

### .listenToOnce(other, event, callback)

## Roadmap

See [milestones](https://github.com/kossnocorp/lisn/issues/milestones).

## Changelog

This project uses [Semantic Versioning](http://semver.org/) for release numbering.

### v0.1.0 (8 Apr, 2013)

First, initial release.

## Contributors

Idea and code by [@kossnocorp](http://koss.nocorp.me/).

Check out full list of [contributors](https://github.com/kossnocorp/lisn/contributors).

## Sponsorship

Sponsored by [Toptal](http://toptal.com/).

## Misc info

This project is a member of the [OSS Manifesto](http://ossmanifesto.org/).

## License

The MIT License

Copyright (c) 2013 Sasha Koss

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
