. ../do.inc
wget --no-check-certificate --no-clobber $(cat urls.txt)
sha256sum -c sha256sums > $3
