chai = require 'chai'
should = chai.should()

X = require '../lib'

describe 'The module object', ->
  it 'should only have five methods: notifier, run, active, poll, subscribe', ->
    X.should.have.keys 'notifier run active poll subscribe'.split ' '
    X.notifier.should.be.a      'function'
    X.run.should.be.a           'function'
    X.active.should.be.a        'function'
    X.poll.should.be.a          'function'
    X.subscribe.should.be.a     'function'
  it 'should be a function itself', ->
    X.should.be.a            'function'