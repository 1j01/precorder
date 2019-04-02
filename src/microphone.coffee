
is_Windows = require('os').type().match(/Windows/)
{spawn} = require('child_process')
{PassThrough} = require('stream')

child_process = null
audio = new PassThrough
info = new PassThrough

start = ->
	return if child_process?
	
	child_process =
		if is_Windows
			spawn('sox', ['-t', 'waveaudio', process.env.PRECORDER_AUDIODEV ? 0, '-p'])
		else
			spawn('rec', ['-p'])
	
	child_process.stdout.pipe(audio)
	child_process.stderr.pipe(info)

stop = ->
	child_process?.kill()
	child_process = null

exports.audioStream = audio
exports.infoStream = info
exports.startCapture = start
exports.stopCapture = stop
