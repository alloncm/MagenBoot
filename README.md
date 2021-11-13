# MagenBoot

A custom copyright free Gameboy (DMG) bootrom Im making for my own GameBoy emulator - [MagenBoy](https://github.com/alloncm/MagenBoy)

## Current state

This project is currently a WIP and developed over a weekend for fun.

This my first time writing an actual software in any kind of assembly so any tips and suggestions are welcomed!

I tried to stracture the file in a sensible way but the code is still a bit messy.

### Features

* Custom boot screen made by me
* Scrolling with a twist

### Future plans

* Cycle accuracy with the original bootrom
* Sound

## Building

* Make sure `make` and `rgbds` are installed. (On Windows both can be installed with chocolatey package manager)
* execute `make`

### Platforms

Built and tested on Windows 10 and Linux (Ubuntu 20.4)

## Tools

The repo also contains a python script to encode a tile data binary file 
in order to inclde it in a small bootrom program (256 bytes).

## Credits

The gbdev community and especially the awsome gbdev [repo](https://github.com/gbdev/awesome-gbdev) for all the great tools and resources
and especially
* [rgbds](https://github.com/gbdev/rgbds) - for the awsome development toolchain
* [The pandocs](https://gbdev.io/pandocs/) - for the awsome docs
* [Harry Mulders Gameboy dev tools](http://www.devrs.com/gb/hmgd/intro.html) - for the awsome tile design tools