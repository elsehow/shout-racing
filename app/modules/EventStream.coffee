Kefir = require 'kefir'
Pusher = require 'pusher-js'

# group visualization
faucet = new Pusher('d5d9a0bbf3ee745375ba', encrypted:true).subscribe('everything')
# subscribes to event on the pubsub & calls emitter.emit on each value it gets
eventStream = (event) -> Kefir.stream (emitter) -> faucet.bind(event, emitter.emit)

module.exports = eventStream