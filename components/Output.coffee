noflo = require 'noflo'

unless noflo.isBrowser()
  util = require 'util'
else
  util =
    inspect: (data) -> data

log = (options, data) ->
  if options?
    console.log util.inspect data,
      options.showHidden, options.depth, options.colors
  else
    console.log data

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Sends the data items to console.log'
  c.icon = 'bug'

  c.inPorts.add 'in',
    datatype: 'all'
    description: 'Packet to be printed through console.log'
  c.inPorts.add 'options',
    datatype: 'object'
    description: 'Options to be passed to console.log'
    control: true
  c.outPorts.add 'out',
    datatype: 'all'

  c.process (input, output) ->
    options = null
    if input.has 'options'
      options = input.getData 'options'

    return unless input.has 'in'
    data = input.getData 'in'
    log options, data
    output.sendDone
      out: data
