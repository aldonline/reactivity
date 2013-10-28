util = require '../lib/util'
chai = require 'chai'
should = chai.should()

s = util.compare_semver

x = """
0.0.0 0.0.0 EQ

0.0.0 0.0.1 LT
0.0.0 0.1.0 LT
0.0.0 1.0.0 LT


0.0.1 0.0.2 LT
0.1.0 0.2.0 LT
1.0.0 2.0.0 LT

1.2.3 3.0.1 LT

1.8.8 3.1.1 LT

3.1.1 1.8.8 GT

"""

get_tests = ->
  lines = ( line.trim() for line in x.trim().split('\n') when line.trim() isnt '' )
  ( p.trim() for p in line.split(' ') when p.trim() isnt '' ) for line in lines


describe 'semver', ->
  it 'should be a function', ->
    s.should.be.a 'function'

  
  for test in get_tests() then do (test) ->
    it test.join(' '), ->
      s( test[0], test[1] ).should.equal test[2]
