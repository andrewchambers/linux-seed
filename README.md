# linux-seed

[![builds.sr.ht status](https://builds.sr.ht/~ach/linux-seed/nixos.yml.svg)](https://builds.sr.ht/~ach/linux-seed/nixos.yml?)

This project is a build script to build a small dependency free statically linked environment for x86_64 linux.

Using a toolchain built using this script, it should then be possible to start from a known point in building
a linux distro or package manager.

The generated toolchain creates dynamically linked binaries that *DONT* refer to the globally installed system dynamic linker,
instead they refer to the installation directory. The reason for this is so the toolchain is totally isolated
from the host system.

## Packages

The environment contains a statically linked gcc with musl libc and the following software:

- bzip2
- dash
- binutils
- coreutils
- diffutils
- gawk
- gcc
- grep
- gzip
- make
- patch
- sed
- tar
- findutils
- xz

The build software does not have any dependency on any host system files other than what is in the output directory.

# How to use

Edit config.inc to match your preferences, then run ./build.sh

By default when the build finishes you will have a non relocateable install at $projectroot/output.

# Notes

- The build system is based on https://github.com/apenwarr/redo, however the project doesn't require this thanks to './support/do'.
- Most patches in the patches directory came from either Nixos or https://github.com/richfelker/musl-cross-make/.
