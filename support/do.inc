# File to be included by do scripts for common
# functionality and config.
set -eu
exec 1>&2
target="$1"
targetbase="$2"
out="$3"

# Coverts foo/pkg-3.5.2.tar.gz to pkg-3.5.2
archivename2packagename () {
  t="$(basename $1)"
  case $1 in
    *.tar.gz)
      echo "${t%.tar.gz}"
    ;;
    *.tar.xz)
      echo "${t%.tar.xz}"
    ;;
  *)
    echo "unknown tar suffix"
    exit 1
    ;;
  esac
}

# Apply all patches in specified directory
applydirpatches () {
    for p in $1/*.patch
    do
      patch -p0 < $p
    done 
}