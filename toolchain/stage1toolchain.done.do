. ../support/do.inc

set -x

redo-ifchange stage1toolchain.srccopied

export PREFIX="$(pwd)/stage1"

cat <<EOF > ./stage1-musl-cross-make/config.mak
TARGET = x86_64-linux-musl
OUTPUT = $PREFIX
MUSL_CONFIG = --syslibdir="$PREFIX/lib/"
COMMON_CONFIG += --disable-nls
GCC_CONFIG += --enable-languages=c,c++
GCC_CONFIG += --disable-libquadmath --disable-decimal-float
GCC_CONFIG += --disable-multilib
EOF

cd stage1-musl-cross-make
make install
cd ..
touch $out