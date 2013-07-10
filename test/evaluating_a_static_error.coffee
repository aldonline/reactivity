chai = require 'chai'
should = chai.should()

mock = require './util/expiring_mock'
X = require '../lib'

describe 'while evaluating a static error', ->
  f = ->
    X()
    throw new Error 'E'
  
  r = X.run f

  describe 'result.result', ->
    it 'should be undefined', ->
      should.not.exist r.result
  
  describe 'result.error', ->
    it 'should be a valid error', ->
      r.error.should.be.an.instanceOf Error
  
  describe 'result.monitor', ->
    it 'should be an object', ->
      r.monitor.should.be.a 'object'

    it 'should not be fired yet', ->
      r.monitor.state().should.equal 'ready'