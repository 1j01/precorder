
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
that I came up with originally while experimenting.
At the very least it can have a different "feel" the second time.
And sometimes I can't remember much of it at all.

If I always started a recording before I played,
I would end up saving a ton of long, largely  mediocre recordings.
I would think, "well, there's some good stuff in there."
I wouldn't listening back to the recordings and edit each one down to contain only whatever good new stuff was in there.

"If only I could go back in time to record."

With this tool, you still have to hit a button to save a recording,
so you don't end up saving lots of stuff you don't really want or care about,
but you don't have to hit a button to record,
so you can capture creative whimsy, post-whimsy.

\#postwhimsy


## Requirements

* A more-or-less dedicated Raspberry Pi or comparable device
* A more-or-less dedicated USB microphone
(or if you want to use a non-USB microphone on the Pi,
you'll need to buy a USB sound card (or perhaps a sound card "HAT"? (Hardware Attached on Top)),
and you may need to [jump through some serious hoops](http://www.g7smy.co.uk/2013/08/recording-sound-on-the-raspberry-pi/))
* Node.js and SoX (installation instructions below)
* Willingness to use the command line
* Who knows, because I haven't gotten this working yet (at least not on the Pi)


## Setup

I'm not sure this thing works yet, so you probably shouldn't bother with it,
but these are the approximate steps it would take:

* `ssh` into (or open a terminal on) the device you wish to use
* Install a recent version of [Node.js][].
The best way is to use [`nvm`][nvm]; that way you can get the latest versions, and can switch versions easily later.
You can run [their installer][nvm installtion] and then run `nvm install --lts` to get a recent, supported version.
* Install [SoX][] with `sudo apt-get install sox`
* Clone the project with `git clone https://github.com/1j01/precorder.git`
* Enter the project folder, i.e. `cd precorder`
* Run `npm i` to install dependencies
* Run `npm link` to make the `precord` CLI available
* Plug in your USB microphone or sound card
* Find an ALSA device ID such as `hw:0,0`
by running `arecord -l` and looking at the numbers where it says `card N` and `device N`;
the ID should be of the form `hw:card,device` where `card` and `device` are the numbers from that command
(maybe it could need `plughw` in place of `hw`, idk)
* Set some environment variables, using the device ID for `PRECORDER_AUDIODEV`:
e.g. `export PRECORDER_AUDIODEV="hw:0,0" ; export AUDIODRIVER="alsa"`
* Run `npm start`
* Wait for it to say "wrote chunk file"; it might show an error at this point
* If it worked, run `precord 1min` to save an audio file in `data/output/`
(and make sure it's an actual recording you can play)

-----

I wanted to use a MobilePre to record stereo from two analog microphones,
but it was an older version of the product so I had to install a driver for it,
specifically "madfuload" (which is made for only a handful of devices).

Also, it seemed like it worked; I could output to the speakers with `speaker-test`;
but I couldn't change any of the levels in `alsamixer`.
Later I found that `arecord` said "Unable to install hw params" which sounds like the same symptom.
Running the same command the next day it didn't get that message.
I think really I just needed to unplug and plug it back in after installing the drivers.

Also, for some reason, it wants to start out with the right channel at zero volume,
which I only figured out by accidentally hitting <kbd>E</kbd> in `alsamixer`
(I was thinking it was detecting it only as a mono device,
which seems like a reasonable thing that could happen;
why would one of the channels just be off by default??)


## TODO

* Get it working!
* Set up `npm start` as a daemon process and allow running at startup; maybe use `npm stop` to stop it
* Make the CLI actually respect the time given
* Make the CLI accept an output file path
* Handle stdout specially: maybe add an alias (`-`); don't output other stuff along with the audio file data
* Make it resilient to disconnecting and reconnecting the mic or soundcard
	(currently it gets something like
	```
	rec WARN alsa: File descriptor in bad state
	rec FAIL sox: `hw:1,0' No such device: Operation not permitted
	In:0.00% 00:12:21.97 [00:00:00.00] Out:35.6M [      |      ]        Clip:0
	Done.
	```
	and then continues on, writing empty chunk files and giving errors about it)
* Polish up and publish to npm

[Node.js]: https://nodejs.org/
[nvm]: https://github.com/creationix/nvm
[nvm installation]: https://github.com/creationix/nvm#installation
[SoX]: http://sox.sourceforge.net/
