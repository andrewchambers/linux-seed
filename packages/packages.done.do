. ../support/do.inc

set -x

pkgs="
  coreutils
  dash
  diffutils
  gawk
  grep
  gzip
  make
  patch
  sed
  tar
  xz
"

for pkg in $pkgs
do
  redo-ifchange $pkg.installed
done
