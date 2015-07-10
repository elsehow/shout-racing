$	= require 'jquery'

setup = (loudestMicStream) ->
	
	$body 		= $(document.body)

	# add a reading a loudest mic value comes in
	loudestMicStream.onValue (car) -> console.log car
		#moveCar(car.name, car.delta))

	# clear the body html to begin
	$body.html('')

module.exports = setup