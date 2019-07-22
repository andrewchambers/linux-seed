. ../support/do.inc

set -x

redo-ifchange ../sources/sources.done
redo-ifchange ../toolchain/toolchain.done

export PATH="$FINAL_OUTPUT/bin:$PATH"

export CC=x86_64-linux-musl-gcc
export CXX=x86_64-linux-musl-g++
export AR=x86_64-linux-musl-ar
export LD=x86_64-linux-musl-ld

prefix="$FINAL_OUTPUT"
tarball="$(realpath ../sources/$2-*)"
packagefullname="$(archivename2packagename "$tarball")"
patchdir="$(realpath "../patches/$packagefullname")"

rm -rf "./${targetbase}_build/"
mkdir "./${targetbase}_build/"
cd "./${targetbase}_build/"
tar xf "$tarball"
cd *

if test -d "$patchdir"
then
  redo-ifchange $patchdir/*.patch
  applydirpatches "$patchdir"
fi

if test -f ./configure
then
  ./configure --prefix="$prefix"
fi

make -j $(nproc) install PREFIX="$prefix"
touch "$out"
