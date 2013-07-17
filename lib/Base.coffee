###
Base class used by Notifier and Monitor.
It provides a basic framework to manage states.
Implementers must implement
@states ( a hashmap of states to handlers )
@public_api ( with handlers )

It also implements a subset of the EventEmitter API
on, off and emit
###
module.exports = class Base

  # States
  state: 'ready'
  transition: (state, f) ->
    t = "#{@state} -> #{state}"
    #unless @state is 'ready' then throw new Error 'Invalid Transition ' + t
    unless state of @states then throw new Error 'Invalid Transition ' + t
    if @state is 'ready'
      f?()
      @state = state
      if typeof ( handler = @states[state] ) is 'string'
        @[ handler ]?()

  # Events
  __listeners: null
  _l: ( event ) -> @__listeners ?= {}
  listeners: ( event ) -> @_l()[event] or []
  on: ( event, listener ) ->
    arr = ( @_l()[event] ?= [] )
    arr.push listener unless listener in arr
    undefined
  off: ( event, listener ) ->
    l = @_l()
    if ( arr = l[event] )?
      l[event] = ( x for x in arr when x isnt listener )
    undefined