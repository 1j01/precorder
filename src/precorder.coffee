
fs = require "fs"
mic = require "./microphone"
date_format = require "date-format"
parse_duration = require "parse-duration"

try
	metadata_json = fs.readFileSync("data/metadata.json", "utf8")
	metadata = JSON.parse(metadata_json)
catch e
	if e instanceof SyntaxError
		console.error("")
		fs.writeFileSync("data/metadata.json", metadata_json, "utf8")
	else if e.code is "ENOENT"
		throw e unless e.code is "ENOENT"
	else
		console.error("Warning: ")
	metadata = {}

try
	fs.mkdirSync("data")
catch e
	throw e unless e.code is "EEXIST"

update_metadata = ->
	# should probably use async
	fs.writeFileSync("data/metadata.json", JSON.stringify(metadata, null, "\t"), "utf8")

metadata.files ?= []

write_stream = null
file = null

chunk_duration = parse_duration("10s")
rolling_total_duration = parse_duration("1min")

record_to_new_file = ->
	mic.audioStream.unpipe()
	write_stream?.end() # will this cut off the end of the file?
	file?.end = Date.now() # should probably wait for end or finish event
	# also want to make sure data isn't duplicated
	
	for file, i in metadata.files by -1
		if (file.end ? file.start + chunk_duration) < Date.now() - rolling_total_duration
			console.log "deleting chunk file:", file.fname
			metadata.files.splice(i, 1)
			fs.unlinkSync(file.fname) # should probably use async
	
	file = {
		fname: "data/#{date_format("yyyy-MM-dd-hhmmss", new Date())}.raw"
		start: Date.now()
	}
	metadata.files.push(file)
	update_metadata()
	
	write_stream = fs.createWriteStream(file.fname)
	mic.audioStream.pipe(write_stream)

	console.log "writing chunk file:", file.fname
	write_stream.on "finish", ->
		chunk_file_size = fs.statSync(file.fname).size
		console.log "wrote chunk file:", file.fname
		console.log "  size:", chunk_file_size, "bytes"
		if chunk_file_size is 0
			console.error "ERROR: no audio data in chunk!"

	setTimeout(record_to_new_file, chunk_duration)

mic.infoStream.setEncoding("utf8")
mic.infoStream.on "data", (data)->
	if data.match /sox FAIL/
		console.error data
	else
		console.log data

console.log "starting up..."
mic.startCapture()

record_to_new_file()
