###
Base class used by Notifier and Monitor.
It provides a basic framework to manage states.
Implementers must implement
@states ( a hashmap of states to handlers )
@public_api ( with handlers )
###
module.exports = class Base
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