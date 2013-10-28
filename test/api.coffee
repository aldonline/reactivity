chai = require 'chai'
should = chai.should()

X = require '../lib'

describe 'The module object', ->
  it 'should have the follwowing props: notifier, run, active, poll, subscribe, version', ->
    X.should.have.keys 'notifier run active poll subscribe version'.split ' '
    X.notifier.should.be.a      'function'
    X.run.should.be.a           'function'
    X.active.should.be.a        'function'
    X.poll.should.be.a          'function'
    X.subscribe.should.be.a     'function'
    X.version.should.be.a       'string'
  it 'should be a function itself', ->
    X.should.be.a            'function'