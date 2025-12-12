#!/bin/bash

echo "Preparing libvncserver..."
cd libvncserver
git init
git remote add origin https://github.com/LibVNC/libvncserver.git
git fetch
git checkout master
cd ..

echo "Preparing framebuffer-vncserver..."
cd framebuffer-vncserver
git init
git remote add origin https://github.com/ponty/framebuffer-vncserver.git
git fetch
git checkout master
cd ..

echo "Preparing openssh-portable..."
cd openssh-portable
git init
git remote add origin https://github.com/openssh/openssh-portable.git
git fetch
git checkout master
cd ..


