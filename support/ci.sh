#! /bin/sh
set -eu

echo "FINAL_OUTPUT=\"/opt/linux-seed/\"" > config.inc
sudo nix-shell --pure ./support/shell.nix --run "/bin/sh ./build.sh"
