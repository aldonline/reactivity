events = require 'events'

###
Base class used by Notifier and Monitor.
It provides a basic framework to manage states.
Implementers must implement
@states ( a hashmap of states to handlers )
@public_api ( with handlers )

It also implements a subset of the EventEmitter API
on, off and emit
###
module.exports = class Base extends events.EventEmitter

  # States
  state: 'ready'
  transition: (state, f) ->
    #unless @state is 'ready' then throw new Error 'Invalid Transition ' + t
    unless state of @states then throw new Error 'Invalid Transition ' + "#{@state} -> #{state}"
    if @state is 'ready'
      f?()
      @state = state
      if typeof ( handler = @states[state] ) is 'string'
        @[ handler ]?()

  # TODO: use a lightweight event emitter implementation
  #       the following code is a start but has a couple of bugs
  ###
  __listeners: null
  _l: -> @__listeners ?= {}
  emit: ( event, e ) ->
    if ( ls = @_l()[event] )?
      x(e) for x in ls
  on: ( event, listener ) ->
    arr = ( @_l()[event] ?= [] )
    arr.push listener unless listener in arr
    undefined
  off: ( event, listener ) ->
    l = @_l()
    if ( arr = l[event] )?
      l[event] = ( x for x in arr when not ( x is listener or x is listener.L ) )
    undefined
  once: ( event, listener ) ->
    l = (e) => @off event, l ; listener e
    l.L = listener
    @on event, l
  ###