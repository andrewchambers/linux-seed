. ../support/do.inc

set -x

redo-ifchange stage1toolchain.done stage2toolchain.srccopied

export PATH="$(pwd)/stage1/bin:$PATH"
export PREFIX="$(pwd)/stage2"

cat <<EOF > ./stage1-musl-cross-make/config.mak
TARGET = x86_64-linux-musl
OUTPUT = $PREFIX
MUSL_CONFIG = --syslibdir="$PREFIX/lib/"
COMMON_CONFIG += --disable-nls
COMMON_CONFIG += CC="x86_64-linux-musl-gcc -static --static"
COMMON_CONFIG += CXX="x86_64-linux-musl-g++ -static --static"
GCC_CONFIG += --enable-languages=c,c++
GCC_CONFIG += --disable-libquadmath --disable-decimal-float
GCC_CONFIG += --disable-multilib
EOF

cd stage2-musl-cross-make
make install
cd ..
touch $out