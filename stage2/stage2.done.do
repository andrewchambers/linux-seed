. ../support/do.inc

set -x

pkgs="
  dash
  coreutils
  gzip
  grep
  patch
  sed
  tar
  xz
  diffutils
  make
"

for pkg in $pkgs
do
  redo-ifchange $pkg.installed
done
