chai = require 'chai'
should = chai.should()

mock = require './util/expiring_mock'

X = require '../lib'

###
Case:
  * We run function1 and get back monitor1
  * monitor1 fires, we execute handler1
  * within handler1 we fire notifier2 ( an unrelated notifier )
  * handler1 finishes executing
  * only then does monitor2 fire
###
describe.skip 'nested invalidations', ->
  it 'should be queued', ->
    
    log = []

    notifier1 = null
    function1 = -> notifier1 = X.notifier()
    monitor1 = X.run(function1).monitor
    monitor1 ->
      # fire notifier from with a handler
      log.push 'monitor1 fired'
      log.push 'before notifier2()'
      notifier2()
      log.push 'after notifier2()'

    notifier2 = null
    function2 = -> notifier2 = X.notifier()
    monitor2 = X.run(function2).monitor
    monitor2 -> log.push 'monitor2 fired'

    log.should.have.length 0

    notifier1()

    log.should.have.length 4

    log.join(', ').should.equal 'monitor1 fired, before notifier2(), after notifier2(), monitor2 fired'

