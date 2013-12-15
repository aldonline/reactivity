chai = require 'chai'
should = chai.should()

X = require '../lib'

delay = -> setTimeout arguments[1], arguments[0]

num = 0
get_num = -> num
get_num_polling = X.poll get_num, 100


describe 'polling...', ->
  it 'should return a function', ->
    r = X.poll get_num, 100
    r.should.be.a 'function'

  it 'this function should return the original value', ->
    r = X.poll get_num, 100
    r().should.equal 0

  it 'and it should return a reactivity monitor alongside the result', ->
    r = X.poll get_num, 100
    {result, monitor} = X.run r
    result.should.equal 0
    should.exist monitor

  it 'should notify when the polling returns a different value', (done) ->

    should.exist get_num_polling()
    get_num_polling().should.equal 0

    {result, monitor} = X.run get_num_polling
    result.should.equal 0
    
    monitor_changed = no
    monitor.on 'change', -> monitor_changed = yes
    monitor_changed.should.equal no
    
    delay 150, ->
      
      monitor_changed.should.equal no
      should.exist get_num_polling()
      get_num_polling().should.equal 0

      num = 1
      monitor_changed.should.equal no
      should.exist get_num_polling()
      get_num_polling().should.equal 1

      delay 100, ->
        monitor_changed.should.equal yes
        get_num_polling().should.equal 1
        done()