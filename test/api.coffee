chai = require 'chai'
should = chai.should()

X = require '../lib'

keys = 'notifier run active poll subscribe version cell'.split ' '

describe 'The module object', ->
  it 'should have the following props: ' + ( keys.join ', ') , ->
    X.should.have.keys keys
    X.notifier.should.be.a      'function'
    X.run.should.be.a           'function'
    X.active.should.be.a        'function'
    X.poll.should.be.a          'function'
    X.subscribe.should.be.a     'function'
    X.cell.should.be.a          'function'
    X.version.should.be.a       'string'
  it 'should be a function itself', ->
    X.should.be.a            'function'