noflo = require 'noflo'

pins =
  pwm3: 3
  pwm5: 5
  pwm6: 6
  pwm9: 1
  pwm10: 7
  pwm11: 4

class Pwm extends noflo.Component
  description: 'Pwm pin definitions'
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

exports.getComponent = -> new Pwm
