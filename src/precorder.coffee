
is_Windows = require('os').type().match(/Windows/)
{spawn} = require('child_process')

fs = require "fs"
mic = require "./microphone"
date_format = require "date-format"
parse_duration = require "parse-duration"

try
	metadata = JSON.parse(fs.readFileSync("data/metadata.json", "utf8"))
catch e
	throw e unless e.code is "ENOENT"
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


console.log "starting up..."
sox_child_process =
	if is_Windows
		spawn('sox', ['-t', 'waveaudio', process.env.PRECORDER_AUDIODEV ? 0, '-p'])
	else
		spawn('rec', ['-p'])

sox_child_process.stderr.setEncoding("utf8")
sox_child_process.stderr.on "data", (data)->
	if data.match /sox FAIL/
		console.error data
	else
		console.log data


record_to_new_file = ->
	sox_child_process.stdout.unpipe()
	write_stream?.end() # will this cut off the end of the file?
	file?.end = Date.now() # should probably wait for end or finish event
	# also want to make sure data isn't duplicated
	
	for file, i in metadata.files by -1
		if (file.end ? file.start + chunk_duration) < Date.now() - rolling_total_duration
			console.log "deleting", file.fname
			metadata.files.splice(i, 1)
			fs.unlinkSync(file.fname) # should probably use async
	
	file = {
		fname: "data/#{date_format("yyyy-MM-dd-hhmmss", new Date())}.raw"
		start: Date.now()
	}
	metadata.files.push(file)
	update_metadata()
	
	write_stream = fs.createWriteStream(file.fname)
	sox_child_process.stdout.pipe(write_stream)
	
	setTimeout(record_to_new_file, chunk_duration)

record_to_new_file()
