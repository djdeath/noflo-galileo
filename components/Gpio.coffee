noflo = require 'noflo'

pins =
  io0: 50
  io1: 51
  io2: 32
  io3: 18
  io4: 28
  io5: 17
  io6: 24
  io7: 27
  io8: 26
  io9: 19
  a0: 44
  a1: 45
  a2: 46
  a3: 47
  a4: 48
  a5: 49
  led: 3

class Gpio extends noflo.Component
  description: 'Gpio pin definitions'
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

exports.getComponent = -> new Gpio
