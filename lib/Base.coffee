events = require 'events'

###
Base class used by Notifier and Monitor.
It provides a basic framework to manage states.
Implementers must implement
@states ( a hashmap of states to handlers )
@public_api ( with handlers )

It also extends events.EventEmitter ( node.js standard )
###
module.exports = class Base extends events.EventEmitter

  # States
  state: 'ready'
  transition: (state, f) ->
    unless state of @states then throw new Error 'Invalid Transition ' + "#{@state} -> #{state}"
    if @state is 'ready'
      f?()
      @state = state
      if typeof ( handler = @states[state] ) is 'string'
        @[ handler ]?()