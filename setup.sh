#!/bin/bash
echo "Install requirements..."
sudo dpkg --add-architecture armel
sudo apt update
sudo apt install g++-arm-linux-gnueabi libasound2-dev libasound2-dev:armel zlib1g-dev:armel

# requirements for fbDOOM
sudo apt install libc6-dev-armel-cross libsdl1.2-dev:armel
