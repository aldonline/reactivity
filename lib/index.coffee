core = require './core'
util = require './util'

build = ->
  {notifier, active, run} = core()
  {subscribe, poll}       = util()

  ###
  m() = notifier()
  
  m( func ) = run(func)
  
  m( func, func ) = subscribe( func, func )

  m( func, interval ) = poll( func, interval )
  
  # more convenient
  m( interval, func ) = poll( func, interval )

  ###
  main = ( x, y ) ->
    switch typeof x + ' ' + typeof y
      when 'undefined undefined' then notifier()
      when 'function undefined'  then run x
      when 'function function'   then subscribe x, y
      when 'function number'     then poll x, y
      when 'number function'     then poll y, x
      else throw new Error 'Invalid Arguments'

  main.notifier    = notifier 
  main.active      = active
  main.run         = run
  main.subscribe   = subscribe
  main.poll        = poll

  main

# only one module can exist per execution environment
# otherwise we would not be able to share the stack
module.exports = ( global or window ).NR ?= build() # lazily build module