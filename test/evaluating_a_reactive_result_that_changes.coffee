chai = require 'chai'
should = chai.should()

mock = require './util/expiring_mock'
X = require '../lib'

describe 'in an evaluation that changes', ->

  f = mock.create()
  r = X.run f

  {result, notifier} = r
  fired = no
  notifier.notify -> fired = yes
  [flag, ex] = result

  describe 'the first result we obtain', ->
    it 'must be true', -> flag.should.equal true

  describe 'but after making a change', ->
    ex()
    describe 'the notifier', ->
      it 'should have fired once', ->
        fired.should.equal true

    describe 'and the new result' ,->
      new_result = f()[0]
      it 'must be false', ->
        new_result.should.equal false