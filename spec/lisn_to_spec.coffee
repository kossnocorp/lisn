Lisn = require('../src/lisn.coffee')
require('../src/lisn_to.coffee')

chai = require('chai')
sinon = require('sinon')
sinonChai = require('sinon-chai')

chai.should()
chai.use(sinonChai)

describe 'LisnTo', ->

  newObj = ->
    obj = {}
    obj[prop] = fn for prop, fn of Lisn
    obj

  beforeEach ->
    @obj = newObj()
    @objB = newObj()
    @spy = sinon.spy()

  describe '.listenTo(other, event, callback)', ->

    it 'binds callback to passed object event', ->
      @obj.listenTo(@objB, 'test', @spy)
      @objB.trigger('test')
      @spy.should.be.calledOnce

    it 'uses current context', ->
      @obj.spy = @spy
      @obj.listenTo(@objB, 'test', (-> @spy()))
      @objB.trigger('test')
      @spy.should.be.calledOnce

    it 'unbinds by off', ->
      @obj.listenTo(@objB, 'test', @spy)
      @objB.off('test', @spy)
      @objB.trigger('test')
      @spy.should.not.be.called

  describe '.stopListening([other], [event], [callback])', ->

    it 'unbinds all binded callbacks where is no arguments', ->
      objC = newObj()
      @obj.listenTo(@objB, 'test', @spy)
      @obj.listenTo(objC,  'test', @spy)
      @obj.stopListening()
      @objB.trigger('test')
      objC.trigger('test')
      @spy.should.not.be.called

    #it 'unbinds only callbacks registread via listenTo', ->
      #objC = newObj()
      #spyB = sinon.spy()
      #@obj.listenTo(@objB, 'test', @spy)
      #@obj.listenTo(objC,  'test', @spy)
      #@objB.on('test', spyB)
      #@obj.stopListening()
      #@objB.trigger('test')
      #objC.trigger('test')
      #@spy.should.not.be.called
      #spyB.should.not.be.calledOnce

    #it 'unbinds callbacks binded to passed object events', ->
      #@obj.listenTo(@objB, 'test',  @spy)
      #@obj.listenTo(@objB, 'test2', @spy)
      #@obj.stopListening(@objB)
      #@objB.trigger('test')
      #@objB.trigger('test2')
      #@spy.should.not.be.called

    #it 'unbinds passed event from specified object', ->
      #spyB = sinon.spy()
      #@obj.listenTo(@objB, 'test',  @spy)
      #@obj.listenTo(@objB, 'test2', spyB)
      #@obj.stopListening(@objB, 'test')
      #@objB.trigger('test')
      #@objB.trigger('test2')
      #@spy.should.not.be.called
      #spyB.should.be.calledOnce

    #it 'unbinds specific callback from passed object event', ->
      #spyB = sinon.spy()
      #@obj.listenTo(@objB, 'test', @spy)
      #@obj.listenTo(@objB, 'test', spyB)
      #@obj.stopListening(@objB, 'test', @spy)
      #@objB.trigger('test')
      #@spy.should.not.be.called
      #spyB.should.be.calledOnce

  describe '.listenToOnce(other, event, callback)', ->

