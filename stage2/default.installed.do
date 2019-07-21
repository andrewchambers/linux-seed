. ../support/do.inc

set -x

redo-ifchange ../sources/fetched.done

prefix="$(pwd)/prefix"
tarball="$(realpath ../sources/$2-*)"
packagefullname="$(archivename2packagename "$tarball")"
patchdir="$(realpath "../patches/$packagefullname")"

rm -rf "./${targetbase}_src/"
mkdir "./${targetbase}_src/"
cd "./${targetbase}_src/"
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

make install PREFIX="$prefix"
touch "$out"
