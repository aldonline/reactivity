Evaluation = require './Evaluation'

module.exports = ->

  stack = []
  
  run = ( f ) ->
    try
      stack.push ev = new Evaluation f
      ev.run()
    finally
      stack.pop()

  notifier = -> stack[stack.length - 1]?.notifier()
  active   = -> stack.length isnt 0

  { notifier, active, run }