noflo = require 'noflo'

pins =
  maxdutycycle: 1000000
  maxperiod: 1000000

class PwmValues extends noflo.Component
  description: 'Pwm values definitions'
  icon: 'book'
  constructor: ->
    @inPorts =
      start: new noflo.Port 'bang'
    @outPorts = {}

    @onAttachReact = false

    for k, v of pins
      @outPorts[k] = new noflo.Port 'number'

    @inPorts.start.on 'data', (value) =>
      @enableReactOnAttach()
      for k, v of pins
        port = @outPorts[k]
        continue unless port.isAttached()
        port.send(v)
        port.disconnect()

  enableReactOnAttach: () ->
    return if @onAttachReact
    for k of pins
      @enablePortReactOnAttach(k)
    @onAttachReact = true

  enablePortReactOnAttach: (portName) ->
    port = @outPorts[portName]
    port.on 'attach', (socket) =>
      socket.send(pins[portName])
      socket.disconnect()

exports.getComponent = -> new PwmValues
