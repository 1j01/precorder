
# Precorder

Psuedo-magically record audio from the past.

As a musician, I like to improvise,
but when I go to record what I just played,
I can often only get the "gist" of it.
It usually loses a lot of the variation
that was there originally from experimentation,
and it can feel different the second time.
Sometimes I can't remember much of it at all.

I could try to always record what I play,
but I would end up saving a ton of mediocre playing
(rather than, say, laboriously editing each recording to contain only whatever good new bits that were recorded).
Plus, consider the difference between the mood of
coming home after a week away to sit down at the old piano and start playing
versus coming home after a week away to go and fetch a laptop, wait for it to boot up, open an audio recording program, hit record, face the laptop down and backwards on top of the piano (so the built-in mic picks up the audio the best it can), and then sit down and start playing.

If only I could go back in time to record.

This utility lets you do just that.
With an always-on system and a dedicated microphone, that is.
Hopefully.


## Requirements

* A Raspberry Pi or similar device
* A dedicated (or semi-dedicated) USB microphone
(if you want to use a non-USB microphone on the Pi,
you may need to [jump through some serious hoops](http://www.g7smy.co.uk/?p=283) including buying a USB soundcard)
* Who knows, because I haven't tested this yet


## Install

Do not try this at home.

(Wait until I actually get this working.)

* Install [Node.js][] and [SoX][] on the device,
  ideally with `sudo apt-get install nodejs sox`
  but that ain't just gonna work
* `git clone` this project onto the device
* `cd` into the project and run `npm i` to install dependencies
* Plug in your microphone
* Run `npm run precorder` and then get that to run in the background somehow
* Run `precord 1min` to save an audio file somewhere
* Make the CLI actually respect the time given
* Fix things, polish up, publish to npm, update this document, all that jazz

<!-- This could be cool if it works with (loud) piano playing: https://github.com/tom-s/clap-detector -->

[Node.js]: https://nodejs.org/
[SoX]: http://sox.sourceforge.net/
