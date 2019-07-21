. ../support/do.inc
set -x

redo-ifchange toolchain.cloned
rm -rf stage1-musl-cross-make
cp -r musl-cross-make stage1-musl-cross-make
touch $out