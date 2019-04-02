
fs = require "fs"
StreamConcat = require "stream-concat"
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

try
	fs.mkdirSync("data/temp")
catch e
	throw e unless e.code is "EEXIST"

combined_raw_file = "data/temp/from-#{date_format("yyyy-MM-dd-hhmmss", new Date(metadata.files[0].start))}.raw"
output_wav_file = "output.wav"

combined_stream.pipe(fs.createWriteStream(combined_raw_file))
combined_stream.on "end", ->
	console.log "wrote", combined_raw_file
	
	n_channels = 2
	sample_rate = 48000
	bit_depth = 16
	
	child_process = spawn("sox", ["-r", sample_rate, "-e", "unsigned-integer", "-b", bit_depth, "-c", n_channels, combined_raw_file, output_wav_file])
	
	child_process.stderr.setEncoding "utf8"
	child_process.stderr.on "data", (data)->
		console.log data
	
	child_process.on "exit", (code, signal)->
		if code is 0
			console.log "sox exited successfully"
			fs.unlinkSync(combined_raw_file)
		else
			console.log "sox exited with code #{code}"
		
