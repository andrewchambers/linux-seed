#! /bin/sh
set -eu

sudo mkdir -p /opt/linux-seed
sudo chown /opt/linux-seed "$(whoami)"
echo "FINAL_OUTPUT=\"/opt/linux-seed/\"" > config.inc
nix-shell --pure ./support/shell.nix --run "/bin/sh ./build.sh"
