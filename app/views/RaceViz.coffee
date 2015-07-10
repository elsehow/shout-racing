$	= require 'jquery'
_	= require 'lodash'

makeCar = (car, index) ->
	return $('<div class = "car"></div>')
			.css 'background-color', car.color
			.css 'top', car.position + '%'
			.css 'left', 50*index

drawRace = ($div, cars) ->
	# clear the div 
	$div.html ''
	# draw each car in its right place
	index = 1	
	_.forEach _.sortBy(cars, 'color'), (car) ->
		$div.append makeCar car, index
		index+=1

showWinner = ($div, car) ->
	msg = $('<h1>WINNNER!!!!!!!!!</h1>')
		.css 'background-color', car.color
	$div.append msg
	$div.append '<img src="assets/solitaire-win.gif">'

setup = (carPositionStream, winnerStream) ->
	
	$body = $(document.body)

	# add a reading a loudest mic value comes in
	carPositionStream.onValue (cars) -> drawRace $body, cars

	carPositionStream.log('car pos')

	winnerStream.onValue (w) -> showWinner $body, w.winner
	winnerStream.log('winner')

	# clear the body html to begin
	$body.html('')

module.exports = setup