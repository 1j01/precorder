
is_Windows = require('os').type().match(/Windows/)
{spawn} = require('child_process')
{PassThrough} = require('stream')

child_process = null
audio = new PassThrough
info = new PassThrough

start = ->
	return if child_process?
	
	n_channels = 2
	sample_rate = 48000
	bit_depth = 16
	
	child_process =
		if is_Windows
			device_number = process.env.PRECORDER_AUDIODEV or '0'
			spawn('sox', ['-t', 'waveaudio', device_number,
				'-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels,
				'-p'])
		else
			spawn('rec', [
				'-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels,
				'-t', 'dat', '-'])
				#'-p'])
	
	child_process.stdout.pipe(audio)
	child_process.stderr.pipe(info)

stop = ->
	child_process?.kill()
	child_process = null

exports.audioStream = audio
exports.infoStream = info
exports.startCapture = start
exports.stopCapture = stop
