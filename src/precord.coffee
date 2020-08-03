
fs = require "fs"
StreamConcat = require "stream-concat"
date_format = require "date-format"
{spawn} = require('child_process')

# TODO: give error if daemon process not running, not only if it hasn't run
# (maybe include PID of daemon in metadata? depends how we do the whole deamon dealio)

try
	metadata = JSON.parse(fs.readFileSync("data/metadata.json", "utf8"))
catch e
	if e.code is "ENOENT"
		console.error "You must setup the background process first!"
		process.exit(1)
	else
		console.error "Failed to read metadata:", e
		process.exit(1)

# console.log "precord let's say 30 seconds"
console.log "save entire rolling audio buffer"

read_streams = for file in metadata.files
	fs.createReadStream(file.fname)

combined_stream = new StreamConcat(read_streams)

for dir_to_ensure in ["data/temp", "data/output"]
	try
		fs.mkdirSync(dir_to_ensure)
	catch e
		throw e unless e.code is "EEXIST"

formatted_start_date = date_format("yyyy-MM-dd-hhmmss", new Date(metadata.files[0].start))
combined_raw_file = "data/temp/from-#{formatted_start_date}.raw"
output_wav_file = "data/output/from-#{formatted_start_date}.wav"

combined_stream.pipe(fs.createWriteStream(combined_raw_file))
combined_stream.on "end", ->
	combined_raw_size = fs.statSync(combined_raw_file).size
	if combined_raw_size is 0
		console.error "ERROR: no audio data!"
		process.exit(1)

	console.log "wrote temporary file:", combined_raw_file
	console.log "  size:", combined_raw_size, "bytes"

	n_channels = 2
	sample_rate = 48000
	bit_depth = 16
	
	child_process = spawn("sox", ["-r", sample_rate, "-e", "unsigned", "-b", bit_depth, "-c", n_channels, combined_raw_file, output_wav_file])
	
	child_process.stderr.setEncoding "utf8"
	child_process.stderr.on "data", (data)->
		console.log data
	
	child_process.on "exit", (code, signal)->
		if code is 0
			console.log "sox exited successfully"
			console.log "output file:", output_wav_file
			output_wav_size = fs.statSync(output_wav_file).size
			console.log "  size:", output_wav_size, "bytes"
			# fs.unlinkSync(combined_raw_file)
		else
			console.log "sox exited with code #{code}"
		
