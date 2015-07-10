_ = require 'lodash'

average = (array) -> 
    return _.sum(array) / array.length

getAverageVolume = (analyzerNode) ->
	array =  new Uint8Array(analyzerNode.frequencyBinCount)
	analyzerNode.getByteFrequencyData array
	return average array

module.exports = getAverageVolume
