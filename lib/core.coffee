Evaluation = require './Evaluation'

module.exports = ->

  stack = []
  
  ###
  Runs a reactive function and returns a Result object
  ###
  run = ( f ) ->
    try
      stack.push ev = new Evaluation f
      ev.run()
    finally
      stack.pop()
  
  # notifier returns undefined if there are no evaluations on the stack
  notifier = -> stack[stack.length - 1]?.notifier()
  active   = -> stack.length isnt 0

  { notifier, active, run }