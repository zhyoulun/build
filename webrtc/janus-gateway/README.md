## mac环境

```bash
brew install jansson libnice openssl srtp libusrsctp libmicrohttpd \
	libwebsockets cmake rabbitmq-c sofia-sip opus libogg curl glib \
	libconfig pkg-config gengetopt autoconf automake libtool

brew reinstall glib


sh autogen.sh

./configure --prefix=/Users/zhangyoulun/temp/janus-gateway/install


```

## ubuntu

```bash
apt install libmicrohttpd-dev libjansson-dev \
	libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
	libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
	libconfig-dev pkg-config gengetopt libtool automake

# 安装pip3
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

# 安装meson
# apt install meson 版本比较老，不行
pip3 install meson
~/.local/bin/meson --version

# libnice
git clone https://gitlab.freedesktop.org/libnice/libnice
~/.local/bin/meson --prefix=/usr build
ninja -C build
sudo ninja -C build install

# libsrtp
wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz
tar xfv v2.2.0.tar.gz
cd libsrtp-2.2.0
./configure --prefix=/usr --enable-openssl
make shared_library && sudo make install

# usrsctp, optional
# git clone https://github.com/sctplab/usrsctp
# cd usrsctp
# ./bootstrap
# ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6
# make && sudo make install

# libwebsockets
git clone https://github.com/warmcat/libwebsockets.git
cd libwebsockets/
mkdir build
cd build/
cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" ..
make
sudo make install

# janus-gateway
git clone https://github.com/meetecho/janus-gateway.git
sh autogen.sh
./configure --prefix=/opt/janus
make
sudo make install
sudo make configs
```

```bash
sudo apt-get install aptitude

sudo aptitude install libmicrohttpd-dev libjansson-dev libnice-dev  libsrtp-dev libsofia-sip-ua-dev     libopus-dev libogg-dev libcurl4-openssl-dev pkg-config gengetopt     libtool automake
# Couldn't find any package whose name or description matched "libglib2.3.4-dev"
# Couldn't find any package whose name or description matched "libssl1.0.1-dev"
```

## 参考

- [ubuntu下更新meson版本](https://blog.csdn.net/ewerwerwerer/article/details/107936762)