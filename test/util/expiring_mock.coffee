chai = require 'chai'
should = chai.should()

X = require '../../lib'

###
A function that returns a series: true, false, true, false
Alongside each result it returns a handle to an invalidator function.
[result, invalidation_handler]
###
exports.create = ->
  flag = false # this means that, on the first call, result will be true
  ->
    flag = !flag
    ex = X.notifier()
    cb = -> ex?()
    [flag, cb]

exports.test_result = (arr) ->
  arr.should.be.an.instanceOf Array
  arr.should.have.length 2
  arr[0].should.be.a 'boolean'
  arr[1].should.be.a 'function'

exports.describe_result = ( res, expected_flag ) ->
  describe 'mock result', ->
    it 'should have a proper structure', ->
      res.should.be.an.instanceOf Array
      res.should.have.length 2
      res[0].should.be.a 'boolean'
      res[1].should.be.a 'function'
    it 'should have a flag', ->
      res[0].should.equal expected_flag