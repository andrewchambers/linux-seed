# File to be included by do scripts for common
# functionality and config.
set -eu
exec 1>&2
target="$1"
targetbase="$2"
out="$3"

_cfgsearchpath="./config.inc"
while true
do
  if test -f "${_cfgsearchpath}"
  then
    break
  fi
  if test "$(realpath ${_cfgsearchpath})" = "/config.inc"
  then
    echo "unable to locate config.inc"
    exit 1
  fi
  _cfgsearchpath="../${_cfgsearchpath}"
done
redo-ifchange "${_cfgsearchpath}"
projectroot="$(dirname "$(realpath "${_cfgsearchpath}")")"
. "${_cfgsearchpath}"
unset _cfgsearchpath

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
  for p in $(find "$1" -name '*.patch' -or -name '*.diff')
  do
    patch -t -p0 < $p || patch -t -p1 < $p
  done 
}
