#!/bin/sh

set -e

uname -a
cc --version
${CC} --version
./configure CC=gcc
make
make clean
./configure CC=clang
make
make clean
sudo DEBIAN_FRONTEND=noninteractive apt-get install libgsm1-dev libsndfile1-dev tcpdump
tcpdump --version || true
mkdir deps
cd deps
wget http://download-mirror.savannah.gnu.org/releases/linphone/plugins/sources/bcg729-1.0.0.tar.gz
tar xfz bcg729-1.0.0.tar.gz
cd bcg729-1.0.0
./configure
make
sudo make install
cd ..
git clone git://github.com/sippy/libg722 libg722
cd libg722
make
sudo make install
cd ../..
sudo ldconfig
libtoolize
autoreconf --force --install --verbose
./configure CC=gcc
make
make check || (cat tests/test-suite.log; exit 1)
make clean
./configure CC=clang
make
make check || (cat tests/test-suite.log ; exit 1)
