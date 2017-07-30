
# Precorder

Psuedo-magically record audio from the past.

When improvising, you can't know when you're *about* to come up with something good.
And you can't always reproduce what you came up with afterwards.
And you shouldn't have to try to.
With Precorder, you don't.

-----

I like to improvise on the piano,
but when I go to record what I just played,
I might recall the "gist" of it,
but I can't remember a lot of the variations
that I came up with while originally experimenting,
At the very least it can have a different "feel" the second time.
At the other end of the scale, sometimes I can't remember much of it at all.

I could try to always record what I play,
but I would end up saving a ton of mediocre playing
(rather than listening back to the recordings and editing each to contain only whatever good new stuff was in there).

If only I could go back in time to record.

This utility basically lets you do that.
With an always-on system and a dedicated microphone, that is.
That's the idea anyways.


## Requirements

* A more-or-less dedicated Raspberry Pi or comparable device
* A more-or-less dedicated USB microphone
(or if you want to use a non-USB microphone on the Pi,
you'll need to buy a USB sound card (or perhaps a sound card "HAT"? (Hardware Attached on Top)),
and you may need to [jump through some serious hoops](http://www.g7smy.co.uk/2013/08/recording-sound-on-the-raspberry-pi/))
* Node.js and SoX (installation instructions below)
* Willingness to use the command line
* Who knows, because I haven't gotten this working yet (on the Pi)


## Setup

I'm not sure this thing works yet, so you probably shouldn't bother with it,
but these are the approximate steps it would take:

* `ssh` into (or open a terminal on) the device you wish to use
* Install a recent version of [Node.js][] if you don't have one.
The best way is to install [`nvm`][nvm]; that way you can get the latest versions, and can switch versions easily later.
You can run [their installer][nvm installtion] and then `nvm install --lts`.
* Install [SoX][],
which can be done with `sudo apt-get install sox`
* Clone this project with `git clone https://github.com/1j01/precorder.git`
* Enter the project folder (i.e. `cd precorder`)
* Run `npm i` to install dependencies
* Run `npm link` to make the `precord` CLI available
* Plug in your USB microphone or sound card
* Find an ALSA ID such as `hw:1,0` with `arecord -L` or something
and set environment variables using the information you somehow obtained,
e.g. `export PRECORDER_AUDIODEV="hw:0,0" ; export AUDIODRIVER="alsa"`
* Run `npm start`
* Run `precord 1min` to save an audio file in `data/output/`


## TODO

* Get it working!
* Set up `npm start` as a daemon process and allow running at startup; maybe use `npm stop` to stop it
* Make the CLI actually respect the time given
* Make the CLI accept an output file path
* Handle stdout specially: maybe add an alias (`-`); don't output other stuff along with the audio file data
* Polish up and publish to npm

[Node.js]: https://nodejs.org/
[nvm]: https://github.com/creationix/nvm
[nvm installation]: https://github.com/creationix/nvm#installation
[SoX]: http://sox.sourceforge.net/
