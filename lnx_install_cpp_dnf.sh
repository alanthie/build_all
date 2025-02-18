#!/bin/bash

# -------------------------------------------------------
# lnx_install_cpp_dnf.sh
#
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
# sudo dnf update
# sudo dnf upgrade
# -------------------------------------------------------

. /etc/os-release 
DISTRO="${ID}_${VERSION_ID}" 

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

function install_pkg()
{
	if dnf info --installed $1 &>/dev/null; then
		echo "already installed $1"
	else
		sudo dnf install -y $1
	fi
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
#sudo dnf update
#sudo dnf upgrade

install_pkg g++
sudo dnf -y install "C Development Tools and Libraries"
install_pkg ccache

# static libgmp.a
install_pkg gmp-static
install_pkg gmp-devel.x86_64
install_pkg gmp-devel gmp-c++

sudo dnf -y copr enable patrickl/libcurl-gnutls
sudo dnf -y install libcurl-gnutls --refresh
install_pkg curl
install_pkg curl-devel

install_pkg cmake
install_pkg git
install_pkg SFML-devel

# CMakeLists.txt set(OpenCV_DIR /usr/lib64/cmake/OpenCV)
install_pkg opencv
install_pkg opencv-devel

sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
install_pkg ffmpeg

# notcurses
install_pkg ffmpeg-free-devel
install_pkg libavcodec-freeworld
install_pkg doctest-devel
install_pkg libdeflate-static
install_pkg libdeflate
install_pkg libdeflate-devel
install_pkg gmp-devel
install_pkg ncurses-compat-libs
install_pkg ncurses-devel
install_pkg libqrcodegen-devel
install_pkg libunistring-devel
install_pkg pandoc 
install_pkg pkgconf-pkg-config


# Catch2
if [ -d "${FOLDER}/Catch2" ]; then
	echo "Directory already exist ${FOLDER}/Catch2 updating..."
	cd "${FOLDER}/Catch2"
	git pull origin devel
else
	cd "${FOLDER}"
	git_clone https://github.com/catchorg/Catch2.git "${FOLDER}/Catch2"
fi

if [ -d "${FOLDER}/Catch2/build" ]; then
	echo "Directory already exist ${FOLDER}/Catch2/build ..."
	cd "${FOLDER}/Catch2/build"
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
	sudo make install
else
	cd "${FOLDER}/Catch2"
	mkdir build
	cd build
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
	sudo make install
fi


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

