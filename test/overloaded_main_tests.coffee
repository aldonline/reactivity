chai   = require 'chai'
should = chai.should()

X        = require '../lib'

describe 'overloaded main', ->
  it 'should return a cell when called with one argument ( that is not a function )', ->
    r = X 1
    # some heuristics to determine if it is a cell
    should.exist r
    r.should.be.a 'function'
    r().should.equal 1
    should.not.exist r(2)
    r().should.equal 2

  it 'should return a cell initialized to undefined when called with no arguments', ->
    new_cell = X()
    # some heuristics to determine if it is a cell
    should.exist new_cell
    new_cell.should.be.a 'function'
    should.not.exist new_cell()
    should.not.exist new_cell 2
    new_cell().should.equal 2

  it 'should run() when a function is passed', ->
    run_result = X -> 1
    should.exist run_result.result
    run_result.result.should.equal 1
    should.not.exist run_result.error
    should.not.exist run_result.monitor

  it 'should subscribe when two functions are passed', (done) ->
    stopper = X (-> 1), (e, r2) ->
      r2.should.equal 1
      done()
    stopper.should.be.a 'function'