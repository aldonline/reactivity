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
  
  # returns a Notifier instance or undefined
  # if there are no evaluations on the stack
  # you can additionally pass a callback, which will
  # be called with one argument ( the Notifier )
  # only if reactivity.active() is true
  # this is a convenience method to save you from
  # doing an if/else check on reactivity.active() or checking
  # if the returned notifier is undefined
  notifier = ( optional_callback ) ->
    n = stack[stack.length - 1]?.notifier()
    if typeof optional_callback is 'function'
      if n? then optional_callback n
    n

  active   = -> stack.length isnt 0

  { notifier, active, run }