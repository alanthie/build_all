#!/bin/bash

# -------------------------------------------------------
# lnx_install_cpp_apt.sh
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
# Update your Linux first
# sudo apt update
# sudo apt upgrade
# -------------------------------------------------------

. /etc/os-release 
DISTRO="${ID}_${VERSION_ID}" 

# -------------------------------------------------------
# SET FOLDER where git repository are downloaded
# SET FOLDERPKG where packages (binaries) are output
# SET BUILDTYPE
# SET BUILD_MEDIAVIEWER_OPTION
# SET BUILD_TEST_OPTION
# -------------------------------------------------------
#BUILDTYPE=Debug
#BUILDTYPElowercase=debug
BUILDTYPE=Release
BUILDTYPElowercase=release

# BUILD_MEDIAVIEWER_OPTION=ON or BUILD_MEDIAVIEWER_OPTION=OFF
BUILD_MEDIAVIEWER_OPTION=ON
BUILD_TEST_OPTION=ON

FOLDER="/home/user/dev"
#FOLDER="/home/alain/dev"
FOLDERPKG="${FOLDER}/build_all/cryptoal/$DISTRO/${BUILDTYPElowercase}"
mkdir "${FOLDER}/build_all/cryptoal"
mkdir "${FOLDER}/build_all/cryptoal/$DISTRO"

echo "GIT Directory ${FOLDER}"
echo "FOLDER PKG Directory ${FOLDERPKG}"
echo "BUILDTYPE ${BUILDTYPE}"
echo "BUILD_MEDIAVIEWER_OPTION ${BUILD_MEDIAVIEWER_OPTION}"
echo "BUILD_TEST_OPTION ${BUILD_TEST_OPTION}"

function isinstalled()
{
	status="$(dpkg-query -W --showformat='${db:Status-Status}' "$1" 2>&1)"
	if [ ! $? = 0 ] || [ ! "$status" = installed ] 
	then
		echo "$1 is not installed"
	else
		echo "$1 is installed"
	fi
}

function install_pkg()
{
	status="$(dpkg-query -W --showformat='${db:Status-Status}' "$1" 2>&1)"
	if [ ! $? = 0 ] || [ ! "$status" = installed ] 
	then
		sudo apt -y install $1
	else
		echo "$1 is already installed"
	fi
}

function remove_pkg()
{
	status="$(dpkg-query -W --showformat='${db:Status-Status}' "$1" 2>&1)"
	if [ ! $? = 0 ] || [ ! "$status" = installed ] 
	then
		echo "$1 is not installed"
	else
		sudo apt -y remove --auto-remove $1
		sudo apt -y purge --auto-remove $1
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

function build_SFML_2_6()
{
	# *.pc are in /usr/lib/x86_64-linux-gnu/pkgconfig
	cd $1
	git clone https://github.com/SFML/SFML.git
	cd SFML
	git checkout 2.6.x
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
}


# MANUAL 
#sudo apt update
#sudo apt upgrade

install_pkg g++
install_pkg build-essential
install_pkg aptitude
install_pkg ccache
install_pkg libgmp-dev
install_pkg libcurl4-gnutls-dev
install_pkg cmake
install_pkg git

if [ "${BUILD_MEDIAVIEWER_OPTION}" = ON ] 
then
	install_pkg libsfml-dev
	install_pkg libudev-dev
	install_pkg libopenal-dev
	install_pkg libvorbis-dev
	install_pkg libflac-dev
	install_pkg libx11-dev 
	install_pkg libxrandr-dev 
	install_pkg libxinerama-dev 
	install_pkg libxcursor-dev 
	install_pkg libxi-dev
	install_pkg libfreetype-dev
	install_pkg libopencv-dev
	install_pkg ffmpeg
fi

# notcurses
install_pkg doctest-dev 
install_pkg libavdevice-dev 
install_pkg libdeflate-dev 
install_pkg libgpm-dev 
install_pkg libncurses-dev 
install_pkg libqrcodegen-dev 
install_pkg libswscale-dev 
install_pkg libunistring-dev 
install_pkg pandoc 
install_pkg pkg-config


# SFML_2_6
if [ "${BUILD_MEDIAVIEWER_OPTION}" = ON ] 
then
	if [ -d "${FOLDER}/SFML" ]; then
		echo "Directory already exist ${FOLDER}/SFML skipping..."
		# ...
	else
		cd "${FOLDER}"
		build_SFML_2_6 "${FOLDER}"
	fi
fi

# Catch2
if [ "${BUILD_TEST_OPTION}" = ON ] 
then
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
	sudo make install
else
	cd "${FOLDER}/libevent"
	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE="${BUILDTYPE}"
	make
	sudo make install
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
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}" -DBUILD_MEDIAVIEWER="${BUILD_MEDIAVIEWER_OPTION}" 
	make
else
	cd "${FOLDER}/cryptochat2"
	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE="${BUILDTYPE}" -DBUILD_MEDIAVIEWER="${BUILD_MEDIAVIEWER_OPTION}" 
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
	cmake .. -DCMAKE_BUILD_TYPE="${BUILDTYPE}" -DBUILD_TEST="${BUILD_TEST_OPTION}" 
	make
else
	cd "${FOLDER}/Encryptions"
	mkdir build
	cd build
	cmake ..  -DCMAKE_BUILD_TYPE="${BUILDTYPE}" -DBUILD_TEST="${BUILD_TEST_OPTION}" 
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
if [ "${BUILD_MEDIAVIEWER_OPTION}" = ON ] 
then
	cp "${FOLDER}/cryptochat2/build/mediaviewer/mediaviewer" "${FOLDERPKG}/"
	mkdir "${FOLDERPKG}/res"
	cp -r "${FOLDER}/cryptochat2/mediaviewer/prj/res"  "${FOLDERPKG}/"
fi
mkdir "${FOLDERPKG}/doc"
cp "${FOLDER}/cryptochat2/release_readme.txt"      "${FOLDERPKG}/doc/chat_readme.txt"
cp "${FOLDER}/Encryptions/README.md"               "${FOLDERPKG}/doc/crypto_readme.md.txt"

exit

