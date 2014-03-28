noflo = require 'noflo'

pins =
  pwm1: 1
  pwm3: 3
  pwm4: 4
  pwm5: 5
  pwm6: 6
  pwm7: 7

class Pwm extends noflo.Component
  description: 'Pwm pin definitions'
  icon: 'book'
  constructor: ->
    @inPorts =
      start: new noflo.Port 'bang'

    @onAttachReact = false

    @outPorts = {}
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
      @enableReactOnAttach(k)
    @onAttachReact = true

  enablePortReactOnAttach: (portName) ->
    port = @outPorts[portName]
    port.on 'attach', (socket) =>
      socket.send(pins[portName])
      socket.disconnect()

exports.getComponent = -> new Pwm
