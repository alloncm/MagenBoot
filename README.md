# MagenBoot

A custom copyright free Gameboy (DMG) bootrom Im making for my own GameBoy emulator - [MagenBoy](https://github.com/alloncm/MagenBoy)

![image](https://user-images.githubusercontent.com/25867720/141697694-a24ea751-7c32-41bd-8d90-e36b9b8bb0c9.png)

## Features

* Custom boot screen made by me
* Scrolling
* Sound

### Future plans

* Opcode accuracy with the original bootrom

## Building

* Make sure `make` and `rgbds` are installed. (On Windows both can be installed with chocolatey package manager)
* run `make`

### Build platforms

* Windows 10
* Linux (Ubuntu 20.04)

## Tools

The repo also contains a python script to encode a tile data binary file 
in order to inclde it in a small bootrom program (256 bytes).

## Credits

The gbdev community and especially the awsome gbdev [repo](https://github.com/gbdev/awesome-gbdev) for all the great tools and resources
and especially
* [rgbds](https://github.com/gbdev/rgbds) - for the awsome development toolchain
* [The pandocs](https://gbdev.io/pandocs/) - for the awsome docs
* [Harry Mulders Gameboy dev tools](http://www.devrs.com/gb/hmgd/intro.html) - for the awsome tile design tools.