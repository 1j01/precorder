
isMacOrWin = require('os').type().match(/Darwin|Windows/)
spawn = require('child_process').spawn
PassThrough = require('stream').PassThrough
lame = require('lame')

child_process = null

audio = new PassThrough
info = new PassThrough

start = (options)->
	options ?= {}
	return if child_process?
	
	child_process =
		if isMacOrWin
			spawn('sox', ['-d', '-t', 'dat', '-p'])
		else
			spawn('arecord', ['-D', 'plughw:1,0', '-f', 'dat'])

	if options.mp3output
		encoder = new lame.Encoder
			channels: 2
			bitDepth: 16
			sampleRate: 44100

		child_process.stdout.pipe(encoder)
		encoder.pipe(audio)
		child_process.stderr.pipe(info)
	else
		child_process.stdout.pipe(audio)
		child_process.stderr.pipe(info)

stop = ->
	if child_process
		child_process.kill()
		child_process = null

exports.audioStream = audio
exports.infoStream = info
exports.startCapture = start
exports.stopCapture = stop
