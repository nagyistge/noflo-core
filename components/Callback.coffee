noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'This component calls a given callback function for each
  IP it receives.  The Callback component is typically used to connect
  NoFlo with external Node.js code.'
  c.icon = 'sign-out'

  c.inPorts.add 'in',
    description: 'Object passed as argument of the callback'
    datatype: 'all'
  c.inPorts.add 'callback',
    description: 'Callback to invoke'
    datatype: 'function'
    control: true
    required: true
  c.outPorts.add 'error',
    datatype: 'object'

  c.process (input, output) ->
    return unless input.has 'callback', 'in'
    [callback, data] = input.get 'callback', 'in'
    unless typeof callback.data is 'function'
      output.sendDone new Error 'The provided callback must be a function'
      return

    return unless data.type is 'data'

    # Call the callback when receiving data
    try
      callback.data data.data
    catch e
      return output.sendDone e
    output.done()
