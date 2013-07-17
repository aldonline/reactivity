chai = require 'chai'
should = chai.should()

Monitor = require '../lib/Monitor'
Notifier = require '../lib/Notifier'

describe 'Monitor', ->
  it 'one notifier', ->
    m = new Monitor
    n = m.evaluation$create_notifier()
    n.should.be.an.instanceOf Notifier

    changed = no
    m.on 'change', -> changed = yes
    
    m.state.should.equal 'ready'
    n.state.should.equal 'ready'

    n.user$fire()

    n.state.should.equal 'fired'
    m.state.should.equal 'changed'

    changed.should.equal yes


  it 'two notifiers', ->
    m = new Monitor
    n = m.evaluation$create_notifier()
    n.should.be.an.instanceOf Notifier
    n2 = m.evaluation$create_notifier()
    n2.should.be.an.instanceOf Notifier

    m_onChange = 0
    n2_onCancel = 0
    m.on 'change', -> m_onChange++
    n2.on 'cancel', -> n2_onCancel++
    
    m.state.should.equal  'ready'
    n.state.should.equal  'ready'
    n2.state.should.equal 'ready'

    n.user$fire()
    m_onChange.should.equal 1
    n2_onCancel.should.equal 1

    n.state.should.equal  'fired'
    m.state.should.equal  'changed'
    n2.state.should.equal 'cancelled'

  it 'destroy monitor', ->
    m = new Monitor
    n = m.evaluation$create_notifier()
    n2 = m.evaluation$create_notifier()

    m.user$destroy()
    m.state.should.equal 'destroyed'
    n.state.should.equal 'cancelled'
    n2.state.should.equal 'cancelled'


  it 'destroy notifiers', ->
    m = new Monitor
    n = m.evaluation$create_notifier()
    n2 = m.evaluation$create_notifier()

    m_onCancel = 0
    m.on 'cancel', -> m_onCancel++

    n.user$destroy()

    m.state.should.equal 'ready'
    n.state.should.equal 'destroyed'
    n2.state.should.equal 'ready'
    m_onCancel.should.equal 0

    n2.user$destroy()

    m.state.should.equal 'cancelled'
    n.state.should.equal 'destroyed'
    n2.state.should.equal 'destroyed'
    m_onCancel.should.equal 1





