chai = require 'chai'
should = chai.should()

mock = require './util/expiring_mock'
X = require '../lib'

describe 'in a reactive result that changes', ->
  it '', ->
    f = mock.create()
    {result, monitor} = X.run f

    fired = no
    monitor.on 'change', -> fired = yes
    [flag, ex] = result

    flag.should.equal true
    
    monitor.state().should.equal 'ready'
    ex()
    monitor.state().should.equal 'changed'

    fired.should.equal true

    new_result = f()[0]
    new_result.should.equal false