
is_Mac_or_Windows = require('os').type().match(/Darwin|Windows/)
{spawn} = require('child_process')
{PassThrough} = require('stream')

child_process = null
audio = new PassThrough
info = new PassThrough

start = ->
	return if child_process?
	
	child_process =
		if is_Mac_or_Windows
			# spawn('sox', ['-d', '-t', 'dat', '-p'])
			# spawn('sox', ['-t', 'waveaudio', '1', 'dat', '-p'])
			spawn('sox', ['-t', 'waveaudio', '0', '-p'])
		else
			spawn('arecord', ['-D', 'plughw:1,0', '-f', 'dat'])
	
	child_process.stdout.pipe(audio)
	child_process.stderr.pipe(info)

stop = ->
	child_process?.kill()
	child_process = null

exports.audioStream = audio
exports.infoStream = info
exports.startCapture = start
exports.stopCapture = stop
