#!/bin/bash

# -------------------------------------------------------
# This will build all my encryption software for Linux
# You can rerun it, and will rebuild the changed parts
# All dependencies are automatically downloaded
# All C++ tools are automatically downloaded
# I often re-install many Linux distros and run this script
# 
# https://github.com/alanthie/Encryptions
# https://github.com/alanthie/cryptochat2
#
# SET FOLDER where git repository are downloaded
# 
# Update your Linux first
# sudo apt update
# sudo apt upgrade
# -------------------------------------------------------

# -------------------------------------------------------
# SET FOLDER where git repository are downloaded
# -------------------------------------------------------
FOLDER="/home/alain/dev"
echo "GIT Directory ${FOLDER}"


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

# TESTING
#isinstalled cmake
#isinstalled cmakegg
#install_pkg quadrapassel
#remove_pkg  quadrapassel
#FOLDER="/home/allaptop/tmp2"
#git_clone https://github.com/alanthie/msgio.git "${FOLDER}/msio"


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
install_pkg libsfml-dev
install_pkg libopencv-dev
install_pkg ffmpeg

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
	cmake ..
	make
	sudo make install
else
	cd "${FOLDER}/notcurses"
	mkdir build
	cd build
	cmake ..
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
	cmake ..
	make
else
	cd "${FOLDER}/libevent"
	mkdir build
	cd build
	cmake ..
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
	cmake ..
	make
else
	cd "${FOLDER}/cryptochat2"
	mkdir build
	cd build
	cmake ..
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
	make
	sudo make install
else
	cd "${FOLDER}/ntl/src"
	./configure 
	make
	# REQUIRE for Encryptions to find NTL/*.h
	sudo make install
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
	cmake ..
	make
else
	cd "${FOLDER}/Encryptions"
	mkdir build
	cd build
	cmake ..
	make
fi



