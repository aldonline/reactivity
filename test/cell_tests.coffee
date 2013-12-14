chai = require 'chai'
should = chai.should()

X = require '../lib'
cell = -> X.cell.apply X, arguments


describe 'a cell', ->
  c1 = cell()
  
  it 'should initially be undefined', -> should.not.exist c1()

  it 'should accept a string', -> c1 'hello'
  
  it 'should now return the string', -> c1().should.equal 'hello'

  it 'should accept a different string', -> c1 'hello2'
  
  it 'should now return the new string', -> c1().should.equal 'hello2'
  
  it 'should return undefined when set', ->
    # this is an important behaviour
    # setting a value that modifies state should not
    # yield any side effects. Only reading allows us to
    # 'see' if something happened.
    # cells are simple functions
    res = c1 'foo'
    should.not.exist res

  it 'should accept an error', ->
    err = new Error 'abc'
    c1 err # passing error

  it 'and throw it...', -> c1.should.throw 'abc'
  
  it 'and throw it again', -> c1.should.throw 'abc'

  it 'should accept callback style passing of values', ->
    r = c1 null, 'foo'
    should.not.exist r
    c1().should.equal 'foo'

  it 'should accept callback style passing of values ( with an error )', ->
    r = c1 new Error('oops'), null
    should.not.exist r
    c1.should.throw 'oops'


describe 'a cell', ->
  it 'should be reactive', ->
    c = cell()
    values = []
    reactivity c, (e, r) -> values.push [e, r]
    values.should.have.length 1
    should.not.exist values[0][0]
    should.not.exist values[0][1]
    
    c 'a'
    values.should.have.length 2
    should.not.exist values[1][0]
    should.exist v = values[1][1]
    v.should.equal 'a'

    c null
    values.should.have.length 3
    should.not.exist values[2][0]
    should.not.exist values[2][1]