#!/bin/bash
echo "Creating/Cleaning binary-folder..."
mkdir bin
rm bin/*.*

echo "Compiling openssh-server..."
cd openssh-portable
autoreconf
./configure --host=arm-linux CC=/usr/bin/arm-linux-gnueabi-gcc AR=/usr/bin/arm-linux-gnueabi-ar --with-libs --without-openssl --disable-etc-default-login --with-privsep-user=root
make
cd ..
cp openssh-portable/sshd bin/
cp openssh-portable/ssh-keygen bin/



echo "Compiling libvncserver..."
cd libvncserver
rm -r build
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=../../files/libvncserver_toolchain.cmake \
        -DCMAKE_INSTALL_PREFIX=/tmp/armv5_libs \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
	-DZLIB_INCLUDE_DIR=/usr/include/ \
	-DZLIB_LIBRARY=/usr/lib/arm-linux-gnueabi/libz.a \
        -DCMAKE_C_FLAGS="-march=armv5t" \
	-DCMAKE_EXE_LINKER_FLAGS="-static -L/usr/lib/arm-linux-gnueabi"
cmake --build .
make install
cd ..
cd ..



echo "Comping framebuffer-vncserver..."
cd framebuffer-vncserver
rm -r build
mkdir -p build && cd build

VNC_LIB_ROOT=/tmp/armv5_libs
ZLIB_LIB_PATH=/usr/lib/arm-linux-gnueabi
cmake .. \
-DCMAKE_TOOLCHAIN_FILE=../../files/framebuffer-vncserver.cmake \
-DCMAKE_INSTALL_PREFIX={$VNC_LIB_ROOT} \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_FLAGS="-march=armv5t -O2 -I${VNC_LIB_ROOT}/include -I/usr/include" \
-DCMAKE_PREFIX_PATH="${VNC_LIB_ROOT}" \
-DCMAKE_FIND_ROOT_PATH="${VNC_LIB_ROOT}" \
-DCMAKE_EXE_LINKER_FLAGS="-static -L${VNC_LIB_ROOT}/lib -L${ZLIB_LIB_PATH} -lvncserver -lpthread -ldl"

make
cd ..
cd ..

cp framebuffer-vncserver/build/framebuffer-vncserver bin/



echo "Compiling fbDOOM..."
cd fbDOOM/fbdoom
ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- make
cd ../..
cp fbDOOM/fbdoom/fbdoom bin/



echo "Compiling InfoNes..."
# applying fix for i.MX25 framebuffer
cp files/InfoNES_System_Linux.cpp arm-NES-linux/linux/
cd arm-NES-linux/linux
make CC=arm-linux-gnueabi-gcc
cd ../../
cp arm-NES-linux/linux/InfoNES bin/

echo "Done."
