Lisn      = require('../src/lisn.litcoffee')

chai      = require('chai')
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.should()
chai.use(sinonChai)

describe 'Lisn', ->

  beforeEach ->
    @obj = {}
    @obj[prop] = fn for prop, fn of Lisn

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

    it 'unbinds binded callback'

    it 'unbinds binded callback from all contexts when context is undefined'

    it 'unbinds binded callback with specified context'

    it 'unbinds all callbacks binded to event then callback is undefined'

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
      @obj.on('test', ((args...)-> @spy(args...)), ctx)
      @obj.trigger('test', 4, 3, 2, 1)
      @spy.should.be.calledWith(4, 3, 2, 1)

    it "doesn't share events", ->
      @obj.on('a', @spy)
      Lisn.trigger('a')
      @spy.should.not.be.called

  describe '.once(event, callback, [context])', ->

    #it 'binds event', ->
      #@obj.once('test', @spy)
      #@obj.trigger('test')
      #@spy.should.be.calledOnce

    #it 'unbinds callback after first trigger'

    #it 'allows to bind to few events separated by spaces', ->
      #@obj.once('a b', @spy)
      #@obj.trigger('a')
      #@obj.trigger('b')
      #@obj.trigger('c')
      #@spy.should.be.calledTwice

    #it 'allows to pass callback context', ->
      #ctx = spy: @spy
      #@obj.once('test', (-> @spy(42)), ctx)
      #@obj.trigger('test')
      #@spy.should.be.calledOnce
      #@spy.should.be.calledWith(42)

    #it 'supports special event "all"', ->
      #@obj.once('all', @spy)
      #@obj.trigger('a')
      #@obj.trigger('b')
      #@obj.trigger('c')
      #@spy.should.be.calledThrice

    #it 'accept args from trigger', ->
      #@obj.once('a', @spy)
      #@obj.trigger('a', 1, 2, 3, 4)
      #@spy.should.be.calledWith(1, 2, 3, 4)

    #it 'calls with specified context', ->
      #ctx = spy: @spy
      #@obj.once('test', ((args...)-> @spy(args...)), ctx)
      #@obj.trigger('test', 4, 3, 2, 1)
      #@spy.should.be.calledWith(4, 3, 2, 1)

    #it "doesn't share events", ->
      #@obj.once('a', @spy)
      #Lisn.trigger('a')
      #@spy.should.not.be.called
