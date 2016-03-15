
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
		# if is_Windows
		# 	# spawn('sox', ['-d', '-t', 'dat', '-p'])
		# 	spawn('sox', ['-t', 'waveaudio', '0', '-p'])
		# else
		if is_Windows
			if process.env.PRECORDER_AUDIODEV # e.g. 1
				spawn('sox', ['-t', 'waveaudio', process.env.PRECORDER_AUDIODEV, '-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p'])
			else
				spawn('sox', ['-t', 'waveaudio', '0', '-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p'])
		# else if process.env.PRECORDER_AUDIODEV
		# 	spawn('sox', [process.env.PRECORDER_AUDIODEV, '-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p'])
		# else
		# 	spawn('sox', ['-d', '-t', 'dat', '-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p'])
		else
			if process.env.PRECORDER_AUDIODEV # e.g. hw:1?
				spawn('rec', [process.env.PRECORDER_AUDIODEV, '-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p'])
			else
				spawn('rec', ['-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p'])
	
	child_process.stdout.pipe(audio)
	child_process.stderr.pipe(info)

stop = ->
	child_process?.kill()
	child_process = null

exports.audioStream = audio
exports.infoStream = info
exports.startCapture = start
exports.stopCapture = stop
