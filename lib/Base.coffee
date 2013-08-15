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