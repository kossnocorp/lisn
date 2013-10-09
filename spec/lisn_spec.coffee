Lisn = require('../src/lisn.coffee')

chai = require('chai')
sinon = require('sinon')
sinonChai = require('sinon-chai')

chai.should()
chai.use(sinonChai)

describe 'Lisn', ->

  newObj = ->
    obj = {}
    obj[prop] = fn for prop, fn of Lisn
    obj

  beforeEach ->
    @obj = newObj()
    @spy = sinon.spy()

  describe '.on(event, callback, [context])', ->

    it 'has alias `bind`', ->
      Lisn.on.should.eq Lisn.bind

    it 'binds event', ->
      @obj.on('test', @spy)
      @obj.trigger('test')
      @spy.should.be.calledOnce

    it 'allows to bind to few events separated by spaces', ->
      @obj.on('a b', @spy)
      @obj.trigger('a')
      @obj.trigger('b')
      @obj.trigger('c')
      @spy.should.be.calledTwice

    it 'allow to specify different callbacks for one event', ->
      spyB = sinon.spy()
      @obj.on('test', @spy)
      @obj.on('test', spyB)
      @obj.trigger('test')
      @spy.should.be.calledOnce
      spyB.should.be.calledOnce

    it 'allows to pass callback context', ->
      ctx = spy: @spy
      @obj.on('test', (-> @spy(42)), ctx)
      @obj.trigger('test')
      @spy.should.be.calledOnce
      @spy.should.be.calledWith(42)

    it 'supports special event "all"', ->
      @obj.on('all', @spy)
      @obj.trigger('a')
      @obj.trigger('b')
      @obj.trigger('c')
      @spy.should.be.calledThrice

  describe '.off([event], [callback], [context])', ->

    it 'has alias unbind', ->
      Lisn.off.should.be.eq Lisn.unbind

    it 'unbinds binded callback', ->
      spyB = sinon.spy()
      @obj.on('a', @spy)
      @obj.on('a', spyB)
      @obj.off('a', @spy)
      @obj.trigger('a')
      @spy.should.not.be.called
      spyB.should.be.calledOnce

    it 'allows to unbind few events separated by speces', ->
      @obj.on('a b', @spy)
      @obj.off('a b', @spy)
      @obj.trigger('a')
      @obj.trigger('b')
      @obj.trigger('c')
      @spy.should.not.be.called

    it 'unbinds binded callback from all contexts when context is undefined', ->
      ctxA = {}
      ctxB = {}
      @obj.on('test', @spy, ctxA)
      @obj.on('test', @spy, ctxB)
      @obj.off('test', @spy)
      @obj.trigger('test')
      @spy.should.not.be.called

    it 'unbinds binded callback with specified context', ->
      ctxA = {}
      ctxB = {}
      spy  = @spy
      callback = -> spy(@)
      @obj.on('test', callback, ctxA)
      @obj.on('test', callback, ctxB)
      @obj.off('test', callback, ctxA)
      @obj.trigger('test')
      @spy.should.be.calledOnce
      @spy.should.be.calledWith(ctxB)

    it 'unbinds all callbacks binded to event then callback is undefined', ->
      spyB = sinon.spy()
      @obj.on('test', @spy)
      @obj.on('test', spyB)
      @obj.off('test')
      @obj.trigger('test')
      @spy.should.not.be.called
      spyB.should.not.be.called

    it 'unbinds all callbacks from given context', ->
      ctxA = {}
      ctxB = {}
      spyB = sinon.spy()
      @obj.on('test', @spy, ctxA)
      @obj.on('test', @spy, ctxA)
      @obj.on('test', spyB, ctxB)
      @obj.off(undefined, undefined, ctxA)
      @obj.trigger('test')
      @spy.should.not.be.called
      spyB.should.be.calledOnce

    it 'unbinds callbacks binded by .once()', ->
      spyB = sinon.spy()
      @obj.once('a', @spy)
      @obj.once('a', spyB)
      @obj.off('a', @spy)
      @obj.trigger('a')
      @spy.should.not.be.called
      spyB.should.be.calledOnce

    it 'allows to unbind few events separated by speces and binded by once', ->
      @obj.once('a b', @spy)
      @obj.off('a b', @spy)
      @obj.trigger('a')
      @obj.trigger('b')
      @obj.trigger('c')
      @spy.should.not.be.called

    it 'unbinds callback binded by once from all contexts when context is undefined', ->
      ctxA = {}
      ctxB = {}
      @obj.once('test', @spy, ctxA)
      @obj.once('test', @spy, ctxB)
      @obj.off('test', @spy)
      @obj.trigger('test')
      @spy.should.not.be.called

    it 'unbinds callback binded by once with specified context', ->
      ctxA = {}
      ctxB = {}
      spy  = @spy
      callback = -> spy(@)
      @obj.once('test', callback, ctxA)
      @obj.once('test', callback, ctxB)
      @obj.off('test', callback, ctxA)
      @obj.trigger('test')
      @spy.should.be.calledOnce
      @spy.should.be.calledWith(ctxB)

    it 'unbinds all callbacks binded to event by once then callback is undefined', ->
      spyB = sinon.spy()
      @obj.once('test', @spy)
      @obj.once('test', spyB)
      @obj.off('test')
      @obj.trigger('test')
      @spy.should.not.be.called
      spyB.should.not.be.called

  describe '.trigger(event, [*args])', ->

    it 'trigger event', ->
      @obj.on('test', @spy)
      @obj.trigger('test')
      @spy.should.be.calledOnce

    it 'pass arguments to binded callback', ->
      @obj.on('a', @spy)
      @obj.trigger('a', 1, 2, 3, 4)
      @spy.should.be.calledWith(1, 2, 3, 4)

    it 'pass arguments to binded callback with context', ->
      ctx = spy: @spy
      @obj.on('test', ((args...) -> @spy(args...)), ctx)
      @obj.trigger('test', 4, 3, 2, 1)
      @spy.should.be.calledWith(4, 3, 2, 1)

    it "doesn't share events", ->
      @obj.on('a', @spy)
      Lisn.trigger('a')
      @spy.should.not.be.called

  describe '.once(event, callback, [context])', ->

    it 'binds event', ->
      @obj.once('test', @spy)
      @obj.trigger('test')
      @spy.should.be.calledOnce

    it 'unbinds after first call', ->
      @obj.once('a b', @spy)
      @obj.trigger('a')
      @obj.trigger('b')
      @spy.should.be.calledOnce

    it 'allow to specify different callbacks for one event', ->
      spyB = sinon.spy()
      @obj.once('test', @spy)
      @obj.once('test', spyB)
      @obj.trigger('test')
      @spy.should.be.calledOnce
      spyB.should.be.calledOnce

    it 'allows to pass callback context', ->
      ctx = spy: @spy
      @obj.once('test', (-> @spy(42)), ctx)
      @obj.trigger('test')
      @spy.should.be.calledOnce
      @spy.should.be.calledWith(42)

    it 'supports special event "all"', ->
      @obj.once('all', @spy)
      @obj.trigger('a')
      @spy.should.be.calledOnce

  describe 'listen functions', ->
