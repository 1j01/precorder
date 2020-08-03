
is_Windows = require('os').type().match(/Windows/)
{spawn, execSync} = require('child_process')
{PassThrough} = require('stream')

child_process = null
audio = new PassThrough
info = new PassThrough

# TODO: make this properly cross-platform

try sox_version = execSync("sox --version").toString("utf8").match(/\bv?(\S*\d\.\d\S*)\b/i)[1]
console.log("SoX version:", sox_version ? "not found")
if not sox_version
	console.error("\nPlease install SoX:\n\n    sudo apt install sox\n")
	process.exit(1)

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
				spawn('rec', [process.env.PRECORDER_AUDIODEV, '-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p', '-'])
			else
				spawn('rec', ['-r', sample_rate, '-e', 'unsigned-integer', '-b', bit_depth, '-c', n_channels, '-p', '-'])
	
	child_process.stdout.pipe(audio)
	child_process.stderr.pipe(info)

stop = ->
	child_process?.kill()
	child_process = null

exports.audioStream = audio
exports.infoStream = info
exports.startCapture = start
exports.stopCapture = stop
