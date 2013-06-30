chai = require 'chai'
should = chai.should()

mock = require './util/expiring_mock'
X = require '../lib'

describe 'in a simple evaluation', ->
  f = mock.create()
  r = X.run f
  describe 'result.result', ->
    it 'should be a valid mock result', ->
      mock.test_result r.result
  describe 'result.error', ->
    it 'should be undefined', ->
      should.equal r.error, undefined
  describe 'result.notifier', ->
    it 'should be an object', ->
      r.notifier.should.be.a 'object'
    it 'should not be fired yet', ->
      r.notifier.fired().should.equal false