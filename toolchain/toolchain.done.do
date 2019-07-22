. ../support/do.inc

set -x

redo-ifchange ../sources/sources.done

target=x86_64-linux-musl
sources=$(realpath ../sources)
patches=$(realpath ../patches)

unpacksrc () {
  name="$1"
  tarball="$(echo $sources/$name-*)"
  mkdir "$name"
  tar -C "$name" --strip-components 1 -xf "$tarball"
}

# Build gcc following a someone hairy and complicated
# build process.
#
# First we unpack the source, apply patches,
# and also patch the dynamic linker path in gcc
# to refer to our final install dir. 
# 
# Next we install linux headers, musl headers
# and binutils into $prefix.
#
# At this point we can build gcc and a static
# libgcc for the target.
# 
# Using that static libgcc we are able to go back
# and build and install musl for our target.
#
# Once musl is installed we can go back and do
# a full build of gcc building all the rest of
# the things that depending on libc.
#
buildgcc () {
  buildstartdir="$(pwd)"
  rm -rf "$prefix" "$builddir"
  mkdir "$builddir"
  cd "$builddir"
  unpacksrc binutils
  unpacksrc musl
  unpacksrc linux
  unpacksrc gcc
  cd gcc
  unpacksrc gmp
  unpacksrc mpc
  unpacksrc mpfr
  applydirpatches "$patches/$(archivename2packagename $(echo $sources/gcc-*))"
  dynlinker="$(echo "$(realpath -m "$prefix/lib/ld-musl-x86_64.so.1")")"
  find . -type f -exec sed -i "s,/lib/ld-musl-x86_64.so.1,$dynlinker,g" "{}" \;
  cd ..
  cd linux
  sed 's,/bin/pwd,pwd,g' -i Makefile
  make ARCH=x86_64 O="$sysroot" headers_install
  cd ..
  mkdir objdir
  cd objdir
  mkdir binutils
  cd binutils
  ../../binutils/configure \
    --prefix="$prefix" \
    --with-sysroot="$sysroot" \
    --target="$target" \
    --disable-multilib \
    --disable-separate-code \
    --disable-werror \
    --enable-deterministic-archives
  make -j $(nproc) all
  make install
  cd ..
  mkdir musl
  cd musl
  ../../musl/configure \
    --prefix="$prefix" \
    --target="$target" \
    --syslibdir="$prefix/lib" \
    --includedir="$prefix/$target/include" \
    --libdir="$prefix/$target/lib"
  make install-headers
  cd ..
  mkdir gcc
  cd gcc
  configure_gcc () {
    ../../gcc/configure \
      --prefix="$prefix" \
      --with-sysroot="$sysroot" \
      --target="$target" \
      --enable-languages=c,c++ \
      --disable-multilib \
      --disable-werror \
      --disable-libmudflap \
      --disable-libsanitizer \
      --disable-gnu-indirect-function \
      --disable-libmpx \
      --enable-libstdcxx-time \
      --enable-tls \
      AR_FOR_TARGET="$prefix/bin/$target-ar" \
      AS_FOR_TARGET="$prefix/bin/$target-as" \
      LD_FOR_TARGET="$prefix/bin/$target-ld" \
      NM_FOR_TARGET="$prefix/bin/$target-nm" \
      OBJCOPY_FOR_TARGET="$prefix/bin/$target-objcopy" \
      OBJDUMP_FOR_TARGET="$prefix/bin/$target-objdump" \
      RANLIB_FOR_TARGET="$prefix/bin/$target-ranlib" \
      READELF_FOR_TARGET="$prefix/bin/$target-readelf" \
      STRIP_FOR_TARGET="$prefix/bin/$target-strip" 
  }
  configure_gcc
  make -j $(nproc) all-gcc
  make -j $(nproc) enable_shared=no all-target-libgcc
  make install-gcc
  cd ..
  cd musl
  make -j $(nproc) CC="$prefix/bin/$target-gcc" LIBCC="../gcc/$target/libgcc/libgcc.a" 
  make install
  cd ..
  rm -rf ./gcc
  mkdir gcc
  cd gcc

  # Rebuild gcc to get shared libgcc this time,
  # We disabled shared libgcc before to let libgcc.a finish without
  # the libc files, now musl is build and installed the
  # libgcc build can finish is broken.

  configure_gcc
  make -j $(nproc)
  make install

  cd "$buildstartdir"
}

builddir="build-gcc-stage1"
prefix="$(pwd)/stage1"
sysroot="$prefix/$target"

buildgcc

export CC="$prefix/bin/$target-gcc -static --static"
export CXX="$prefix/bin/$target-g++ -static --static"
export LD="$prefix/bin/$target-ld"

builddir="build-gcc-stage2"
prefix="$FINAL_OUTPUT"
sysroot="$prefix/$target"

buildgcc

touch $out
