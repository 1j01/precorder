#!/usr/bin/env node

var arg = process.argv[2];

var help = "\n\
Usage: precord [time]\n\
\n\
Examples:\n\
\n\
  $ precord 5min\n\
  $ precord 10s\n\
\n\
Options:\n\
\n\
  -h, --help     output usage information\n\
  -V, --version  output the version number\n\
";

if(!arg || arg.match(/^(--help|-h|help)$/)){
	console.log(help);
}else if(arg.match(/^(-v|-V|--version)$/)){
	console.log(require("./package").version);
}else{
	console.log(arg, "huh? how about just the whole thing?");
	require("coffee-script/register");
	require("./precord.coffee");
}
