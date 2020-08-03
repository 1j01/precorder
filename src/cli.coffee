
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
	console.log "(ignoring arument) #{arg}, you say? how about just whatever is in the rolling audio buffer?"
	require("./precord.coffee")
