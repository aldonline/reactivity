core       = require './core'
_poll      = require './poll'
_subscribe = require './subscribe'
version    = require './version'
util       = require './util'
_cell      = require './cell'

###
Main entry point to the reactivity framework.
Exports an object that exposes the 5 API methods.
The object is itself an overloaded function that proxies
to the methods for convenience.
###
build = ->
  
  {notifier, active, run}    = _c = core()
  # we pass core module as dependency
  # to avoid multiple instantiation
  subscribe = _subscribe _c
  poll      = _poll _c
  cell      = _cell _c

  main = ->
    c = cell()
    c arguments[0] if arguments.length is 1
    c

  main.notifier       = notifier 
  main.active         = active
  main.run            = run
  main.subscribe      = subscribe
  main.poll           = poll
  main.cell           = cell
  main.version        = version
  main

# only one module can exist per execution environment
# this is necessary for interoperability between different
# libraries

GLOBAL = ( global or window )

# only build and replace if we are newer than the existing implementation
do conditional_build = ->
  create = false
  if ( other = GLOBAL.reactivity )?
    other_version = other.version or '0.0.0'
    if ( util.compare_semver( version, other_version) is 'GT' )
      create = yes
  else
    create = yes

  if create then GLOBAL.reactivity = build()

module.exports = GLOBAL.reactivity