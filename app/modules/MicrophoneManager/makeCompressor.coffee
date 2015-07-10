makeCompressor = (audioctx) ->
	compressor = audioctx.createDynamicsCompressor()
	compressor.threshold.value = -50
	compressor.knee.value = 40
	compressor.ratio.value = 12
	compressor.reduction.value = -20
	compressor.attack.value = 0 
	compressor.release.value = 0.25
	compressor

module.exports = makeCompressor