#! /bin/sh
set -eux

sudo mkdir -p /opt/linux-seed
sudo chown "$(whoami)" /opt/linux-seed
echo "FINAL_OUTPUT=\"/opt/linux-seed\"" > config.inc
nix-shell --pure ./support/shell.nix --run "/bin/sh ./build.sh"
