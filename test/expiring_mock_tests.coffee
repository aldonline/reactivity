chai = require 'chai'
should = chai.should()

mock = require './util/expiring_mock'

describe 'expiring mock', ->
  f = mock.create()
  ex = undefined
  it 'should return both a value and an RC', ->
    res = f()
    mock.test_result res
    [r, ex] = res
    r.should.equal true
  it 'should return a value when expired', ->
    ex()
    res = f()
    mock.test_result res
    [r, ex] = res
    r.should.equal false
  it 'should return a different value when expired for the second time', ->
    ex()
    res = f()
    mock.test_result res
    [r, ex] = res
    r.should.equal true