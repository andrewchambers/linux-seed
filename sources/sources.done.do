. ../support/do.inc
set -x
redo-ifchange urls.txt
wget --no-check-certificate --no-clobber $(cat urls.txt)
test -f sha256sums || sha256sum *.tar.* > sha256sums
test "$(wc -l < sha256sums)" = "$(wc -l < urls.txt)"
sha256sum -c sha256sums > "$out"
