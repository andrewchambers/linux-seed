. ../support/do.inc

rm -rf ./musl-cross-make
GIT_SSL_NO_VERIFY=true git clone https://github.com/andrewchambers/musl-cross-make 
cd musl-cross-make
git checkout ed59795b637c134913d1e26f21ccffc974dc3364
git fsck
cd ..
touch "$out"
