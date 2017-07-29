
{version} = require("../package")

arg = process.argv[2]

help = """
	Usage: precord [time]

	Examples:

	  $ precord 5min
	  $ precord 10s

	Options:

	  -h, --help     output usage information
	  -V, --version  output the version number
"""

if not arg or arg in ["--help", "-h"]
	console.log help
else if arg in ["--version", "-V", "-v"]
	console.log version
else
	console.log "#{arg}, huh? how about just the whole thing?"
	require("./precord.coffee")
