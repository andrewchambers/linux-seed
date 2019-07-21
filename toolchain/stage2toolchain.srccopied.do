. ../support/do.inc
set -x

redo-ifchange toolchain.cloned
rm -rf stage2-musl-cross-make
cp -r musl-cross-make stage2-musl-cross-make
touch $out