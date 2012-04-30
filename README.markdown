# Tyler: a toolkit for touch-enabled roleplaying games

Tyler is an open-source (MIT license) toolkit for building tile-based console RPGs, similar to the early Final Fantasy games. It lets you build games that run in a Web browser, or that could be bundled into a mobile app. Games are designed to work great on touchscreen devices, but can also be played with keyboard and mouse.

Tyler's current status is "**barely started**" (or "**vaporware**" if you prefer).

## How it works

Tyler is a compiler. You create a "game project" (a directory full of [JSON][] and script files that define your characters, maps, items, etc.), and you use Tyler to compile your project into a Web-based game. Tyler also contains a runtime library with a map system, battle system, etc., which is automatically included into compiled games.

Most of this isn't working yet.

## What it can do so far

* Create a Web page that shows the name of the sample game
* ...uh, yeah, that's it.

I'm currently working on the logic behind the battle system, but there's not much to see yet (besides the tests).

## Getting started

First, see the above warnings about the current status. Don't expect much yet.

Tyler is written using [Node.js][]. The source code is written in [IcedCoffeeScript][].

To play around with it, follow these steps:

* Install [Node.js].
* Check out the Tyler repository.
* Open a command prompt in your checkout directory.
* `npm install` -- This will install Tyler's dependencies ([IcedCoffeeScript][], [Mocha][], etc).
* `npm install -g jake` -- Installs [Jake][], which is used to build Tyler and run its tests.
* `jake` -- Builds Tyler, runs the tests, and builds the sample game.

You can now open `sample/www/index.html` in a Web browser. Exciting!

Or you can hack on the code. Tests are in `test/*.iced`, the source code for the battle-system runtime library is in `runtime/battle`, the [Eco][] template for the HTML page is in `runtime/view`, and the build logic behind the Jakefile is in `build/`. A more complete introduction will be forthcoming once there's more to see.

  [Eco]: https://github.com/sstephenson/eco
  [IcedCoffeeScript]: http://maxtaco.github.com/coffee-script/
  [Jake]: https://github.com/mde/jake
  [JSON]: http://www.json.org/
  [Mocha]: http://visionmedia.github.com/mocha/
  [Node.js]: http://nodejs.org/