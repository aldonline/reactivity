module.exports = class Result
  constructor: ( { @error, @result, @monitor } ) ->
  get: ->
    throw @error if @error?
    @result