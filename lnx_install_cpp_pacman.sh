#!/bin/bash

# -------------------------------------------------------
# lnx_install_cpp_pacman.sh
# This will build all my encryption software for Linux
# You can rerun it, and will rebuild the changed parts
# All dependencies are automatically downloaded
# All C++ tools are automatically downloaded
# I often re-install many Linux distros and run this script
# 
# Projects being build:
# https://github.com/alanthie/Encryptions
# https://github.com/alanthie/cryptochat2
#
# SET FOLDER where git repository are downloaded
# SET FOLDER where packages (binaries) are output
# SET BUILDTYPE
# 
# Update your Linux first
# sudo pacman -Syu
#  
# -------------------------------------------------------

. /etc/os-release 
DISTRO="${ID}_${VERSION_ID}" 
# DISTRO=cachyos_250202
DISTRO=cachyos_250202
#
#

# -------------------------------------------------------
# SET FOLDER where git repository are downloaded
# SET FOLDER where packages (binaries) are output
# SET BUILDTYPE
# -------------------------------------------------------
#BUILDTYPE=Debug
#BUILDTYPElowercase=debug
BUILDTYPE=Release
BUILDTYPElowercase=release

#FOLDER="/home/user/dev"
FOLDER="/home/alain/dev"
FOLDERPKG="${FOLDER}/build_all/cryptoal/$DISTRO/${BUILDTYPElowercase}"
mkdir "${FOLDER}/build_all/cryptoal"
mkdir "${FOLDER}/build_all/cryptoal/$DISTRO"

echo "GIT Directory ${FOLDER}"
echo "GIT Directory ${FOLDERPKG}"
echo "BUILDTYPE ${BUILDTYPE}"
echo "DISTRO ${DISTRO}"


function build_SFML_2_6()
{
	cd /home/alain/dev
	git clone https://github.com/SFML/SFML.git
	cd SFML
	git checkout 2.6.x
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
}


function install_pkg()
{
	sudo pacman -S --needed $1
}

function git_clone()
{
	if [ -d "$2" ]; then
		echo "Directory already exist $2 ..."
	else
		mkdir $2
		git clone $1 $2
	fi
}

# MANUAL 
# sudo pacman -Syu
# 

install_pkg gcc
install_pkg base-devel
install_pkg ccache

# MANUAL
# static libgmp.a
# Arch:
# sudo pacman -S yay
# yay -S libgmp-static
# libtool --finish /usr/lib
install_pkg gmp

pacman -S --noconfirm curl

install_pkg cmake
install_pkg git

# MANUAL
#build_SFML_2_6

# Arch set(OpenCV_DIR /usr/lib/cmake/opencv4/)
install_pkg opencv
sudo pacman -Sy vtk hdf5

install_pkg ffmpeg

# notcurses
install_pkg doctest
install_pkg libdeflate
install_pkg ncurses
install_pkg libunistring
install_pkg pandoc 
install_pkg pkgconf


# notcurses
if [ -d "${FOLDER}/notcurses" ]; then
	echo "Directory already exist ${FOLDER}/notcurses updating..."
	cd "${FOLDER}/notcurses"
	git pull origin master
else
	cd "${FOLDER}"
	git_clone https://github.com/alanthie/notcurses.git "${FOLDER}/notcurses"
fi

if [ -d "${FOLDER}/notcurses/build" ]; then
	echo "Directory already exist ${FOLDER}/notcurses/build ..."
	cd "${FOLDER}/notcurses/build"
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
	sudo make install
else
	cd "${FOLDER}/notcurses"
	mkdir build
	cd build
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
	# REQUIRE later to find *.h
	sudo make install
fi
	

# wide-integer
if [ -d "${FOLDER}/wide-integer" ]; then
	echo "Directory already exist ${FOLDER}/wide-integer updating..."
	cd "${FOLDER}/wide-integer"
	git pull origin master
else
	cd "${FOLDER}"
	git_clone  https://github.com/ckormanyos/wide-integer.git "${FOLDER}/wide-integer"
fi


# wide-decimal
if [ -d "${FOLDER}/wide-decimal" ]; then
	echo "Directory already exist ${FOLDER}/wide-decimal updating..."
	cd "${FOLDER}/wide-decimal"
	git pull origin main
else
	cd "${FOLDER}"
	git_clone  https://github.com/ckormanyos/wide-decimal.git "${FOLDER}/wide-decimal"
fi
 
 
# libevent
if [ -d "${FOLDER}/libevent" ]; then
	echo "Directory already exist ${FOLDER}/libevent updating..."
	cd "${FOLDER}/libevent"
	git pull origin master
else
	cd "${FOLDER}"
	git_clone   https://github.com/libevent/libevent.git "${FOLDER}/libevent"
fi

if [ -d "${FOLDER}/libevent/build" ]; then
	echo "Directory already exist ${FOLDER}/libevent/build ..."
	cd "${FOLDER}/libevent/build"
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
else
	cd "${FOLDER}/libevent"
	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
fi


#copy event-config.h from build to event2 folder if missing
#From /home/alain/dev/libevent/build/include/event2/event-config.h
# /home/alain/dev/libevent/include/event2/
if [ -f "${FOLDER}/libevent/include/event2/event-config.h" ]; then
	echo "File already exist ${FOLDER}/libevent/include/event2/event-config.h..."
else
	cp "${FOLDER}/libevent/build/include/event2/event-config.h" "${FOLDER}/libevent/include/event2/"
fi

# TODO add link_directories in cmake files /usr/lib64/ for /usr/lib64/libgmp.a
# TODO for cryptochat2/mediaviewer project
# SFML 2.2 is not loaded, it load the most recent version, compile from sources...
#

# cryptochat2
if [ -d "${FOLDER}/cryptochat2" ]; then
	echo "Directory already exist ${FOLDER}/cryptochat2 updating..."
	cd "${FOLDER}/cryptochat2"
	git pull origin main
else
	cd "${FOLDER}"
	# git clone ssh://gituser@192.168.0.23:/volume1/git/cryptochatal
	git_clone   https://github.com/alanthie/cryptochat2.git "${FOLDER}/cryptochat2"
fi

if [ -d "${FOLDER}/cryptochat2/build" ]; then
	echo "Directory already exist ${FOLDER}/cryptochat2/build ..."
	cd "${FOLDER}/cryptochat2/build"
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
else
	cd "${FOLDER}/cryptochat2"
	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
fi


# ntl
if [ -d "${FOLDER}/ntl" ]; then
	echo "Directory already exist ${FOLDER}/ntl updating..."
	cd "${FOLDER}/ntl"
	git pull origin main
else
	git_clone   https://github.com/libntl/ntl.git  "${FOLDER}/ntl"
fi

if [ -f "${FOLDER}/ntl/src/ntl.a" ]; then
	echo "File already exist ${FOLDER}/ntl/src/ntl.a ..."
	cd "${FOLDER}/ntl/src"
	if [ "${BUILDTYPE}" = Release ] 
	then
		export CFLAGS="-O2"
		export CXXFLAGS="-O2"
	fi
	# TODO - Detect if we should redo ./configure
	#./configure
	make
	sudo make install
	if [ "${BUILDTYPE}" = Release ] 
	then
		unset CFLAGS
		unset CXXFLAGS
	fi
else
	cd "${FOLDER}/ntl/src"
	if [ "${BUILDTYPE}" = Release ] 
	then
		export CFLAGS="-O2"
		export CXXFLAGS="-O2"
	fi
	./configure 
	make
	# REQUIRE for Encryptions to find NTL/*.h
	sudo make install
	if [ "${BUILDTYPE}" = Release ] 
	then
		unset CFLAGS
		unset CXXFLAGS
	fi
fi


# Encryptions
if [ -d "${FOLDER}/Encryptions" ]; then
	echo "Directory already exist ${FOLDER}/Encryptions updating..."
	cd "${FOLDER}/Encryptions"
	git pull origin master
else
	git_clone   https://github.com/alanthie/Encryptions.git "${FOLDER}/Encryptions"
fi

if [ -d "${FOLDER}/Encryptions/build" ]; then
	echo "Directory already exist ${FOLDER}/Encryptions/build ..."
	cd "${FOLDER}/Encryptions/build"
	cmake .. -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
else
	cd "${FOLDER}/Encryptions"
	mkdir build
	cd build
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
fi


# -------------------------------------------------------
# Copy programs
# -------------------------------------------------------
if [ -d "${FOLDERPKG}" ]; then
	echo "Directory already exist ${FOLDERPKG} deleting..."
	rm -r "${FOLDERPKG}"
fi
mkdir "${FOLDERPKG}"
cp "${FOLDER}/Encryptions/build/src/crypto" "${FOLDERPKG}/"
cp "${FOLDER}/Encryptions/build/src/qa/qa"  "${FOLDERPKG}/"
cp "${FOLDER}/cryptochat2/build/lnx_chatcli/lnx_chatcli" "${FOLDERPKG}/"
cp "${FOLDER}/cryptochat2/build/lnx_chatsrv/lnx_chatsrv" "${FOLDERPKG}/"
cp "${FOLDER}/cryptochat2/build/mediaviewer/mediaviewer" "${FOLDERPKG}/"
mkdir "${FOLDERPKG}/res"
cp -r "${FOLDER}/cryptochat2/mediaviewer/prj/res"  "${FOLDERPKG}/"
mkdir "${FOLDERPKG}/doc"
cp "${FOLDER}/cryptochat2/release_readme.txt"      "${FOLDERPKG}/doc/chat_readme.txt"
cp "${FOLDER}/Encryptions/README.md"               "${FOLDERPKG}/doc/crypto_readme.md.txt"

exit

