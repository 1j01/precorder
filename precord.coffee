
fs = require "fs"
StreamConcat = require "stream-concat"
# wav = require "wav"
date_format = require "date-format"
{spawn} = require('child_process')

try
	metadata = JSON.parse(fs.readFileSync("data/metadata.json", "utf8"))
catch e
	if e.code is "ENOENT"
		console.error "You must setup the background process first!"
	else
		console.error "Failed to read metadata:", e

# console.log "precord let's say 30 seconds"
console.log "save entire rolling audio buffer"

read_streams = for file in metadata.files
	fs.createReadStream(file.fname)

combined_stream = new StreamConcat(read_streams)

# console.log "to test.wav"
# wav_writer = new wav.FileWriter "test.wav",
# 	# TODO: get values from metadata
# 	channels: 2
# 	sampleRate: 48000
# 	bitDepth: 16

# combined_stream.pipe(wav_writer)

try
	fs.mkdirSync("data/temp")
catch e
	throw e unless e.code is "EEXIST"

# combined_pcm_file = "data/temp/from-#{metadata.files[0].fname}"
combined_pcm_file = "data/temp/from-#{date_format("yyyy-MM-dd-hhmmss", new Date(metadata.files[0].start))}.pcm"
output_wav_file = "output.wav"

combined_stream.pipe(fs.createWriteStream(combined_pcm_file))
combined_stream.on "end", ->
	# console.log "combined stream ended"
	console.log "wrote", combined_pcm_file

	n_channels = 2
	sample_rate = 48000
	bit_depth = 16

	child_process = spawn("sox", ["-r", sample_rate, "-e", "unsigned", "-b", bit_depth, "-c", n_channels, combined_pcm_file, output_wav_file])

	child_process.stderr.setEncoding "utf8"
	child_process.stderr.on "data", (data)->
		console.log data
	
	child_process.on "exit", (code, signal)->
		if code is 0
			console.log "sox exited successfully"
			fs.unlinkSync(combined_pcm_file)
		else
			console.log "sox exited with code #{code}"
		
