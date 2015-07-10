$		= require 'jquery'

loginTemplate = () ->
	'''
	<h2>Choose a color to represent your microphone!:</h2>
	<button style="background-color:#fff000" class="selectColorButton" />
	<button style="background-color:#000fff" class="selectColorButton" />
	<button style="background-color:#ff0000" class="selectColorButton" />
	<button style="background-color:#00ff00" class="selectColorButton" />
	<button style="background-color:#f000ff" class="selectColorButton" />
	'''

setup = (cb) ->

	# setup the template
	$body 				= $(document.body)
	$body.html(loginTemplate())
	$selectColorButton	= $('.selectColorButton')
	
	# when join button is pressed,
	# call cb on the prodcuced config object
	$selectColorButton.on 'click', (e) ->
		selectedColor = $(e.target).css('background-color')
		cb(selectedColor)

module.exports = setup