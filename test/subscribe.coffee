chai = require 'chai'
should = chai.should()
assert = require 'assert'

X = require '../lib'

SERIAL = 0

# creates a function that registers an invalidator every time it is called
# we return both the function and a function that will call the current invalidator
create_func_with_notifier = ->
  notifier = null
  f = ->
    notifier = X.notifier()
    if (r = SERIAL++) is 2 then throw new Error '2 is no good'
    r
  cb = ->
    should.exist notifier
    notifier.should.be.a 'function'
    notifier()
  [ cb, f ]

describe 'a subscription', ->
  [inv, f] = create_func_with_notifier()
  arr = []
  # our callback will push all arguments into arr so we can inspect them
  stop_subscribe = X.subscribe f, -> arr.push arguments

  it 'should return a stop() function', ->
    stop_subscribe.should.be.a 'function'
  
  it 'should apply f once as soon as it is started', ->
    SERIAL.should.equal 1 # we know it called f because SERIAL increased by one
    arr.should.have.length 1 # and we have a copy of the arguments stored here
    should.not.exist arr[0][0] # the first argument ( the error ) should not exist
    arr[0][1] is 0 # only the value, which is the previous value of SERIAL

  it 'should emit a second response once f is invalidated', ->
    inv()
    SERIAL.should.equal 2
    arr.should.have.length 2
    should.not.exist arr[1][0] # no errors
    arr[1][1] is 1
  
  it 'should emit an error on the next invalidation', ->
    inv()
    SERIAL.should.equal 3
    arr.should.have.length 3
    arr[2][0].should.be.an.instanceOf Error # an error
    should.not.exist arr[2][1]


  it 'should emit a third response once f is invalidated', ->
    inv()
    SERIAL.should.equal 4
    arr.should.have.length 4
    should.not.exist arr[3][0] # no errors
    arr[3][1] is 2

  it 'should stop reacting to invalidations when stop() is called', ->
    stop_subscribe()
    # we invalidate
    inv()
    # but this time nothing should happen
    SERIAL.should.equal 4 # same length as before
    arr.should.have.length 4 # same length as before

