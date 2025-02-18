#!/bin/bash

# -------------------------------------------------------
# This will archive your local git repositories
#
# Change the script for your need
# git source folder : ~/dev
# archive destination folder : ~/dev_zip
# -------------------------------------------------------

if [ -d ~/dev/config_netw ]; then
	cd ~/dev/config_netw
	git archive --format=zip --output ~/dev_zip/config_netw.zip master -v
fi

cd ~/dev/build_all
status=$?
if [ $status -eq 0 ]
then
	echo "archiving build_all.zip"
	git archive --format=zip --output ~/dev_zip/build_all.zip main -v
else
	echo "cannot - cd ~/dev/build_all"
fi

if [ -d ~/dev/Catch2 ]; then
	cd ~/dev/Catch2
	git archive --format=zip --output ~/dev_zip/Catch2.zip devel -v
fi

if [ -d ~/dev/SFML ]; then
	cd ~/dev/SFML
	git archive --format=zip --output ~/dev_zip/SFML.zip 2.6.x -v
fi

if [ -d ~/dev/cryptochat2 ]; then
	cd ~/dev/cryptochat2
	git archive --format=zip --output ~/dev_zip/cryptochat2.zip main -v
fi

if [ -d ~/dev/libevent ]; then
	cd ~/dev/libevent
	git archive --format=zip --output ~/dev_zip/libevent.zip master -v
fi

if [ -d ~/dev/notcurses ]; then
	cd ~/dev/notcurses
	git archive --format=zip --output ~/dev_zip/notcurses.zip master -v
fi

if [ -d ~/dev/msgio ]; then
	cd ~/dev/msgio
	git archive --format=zip --output ~/dev_zip/msgio.zip main -v
fi

if [ -d ~/dev/cryptochat_github ]; then
	cd ~/dev/cryptochat_github
	git archive --format=zip --output ~/dev_zip/cryptochat_github.zip main -v
fi

if [ -d ~/dev/ntl ]; then
	cd ~/dev/ntl
	git archive --format=zip --output ~/dev_zip/ntl.zip main -v
fi

if [ -d ~/dev/Encryptions ]; then
	cd ~/dev/Encryptions
	git archive --format=zip --output ~/dev_zip/Encryptions.zip master -v
fi

if [ -d ~/dev/ini_parser ]; then
	cd ~/dev/ini_parser
	git archive --format=zip --output ~/dev_zip/ini_parser.zip master -v
fi

if [ -d ~/dev/NanoLog ]; then
	cd ~/dev/NanoLog
	git archive --format=zip --output ~/dev_zip/NanoLog.zip master -v
fi

exit

# -------------------------------------------------------
# Extra
#
# Change the script for your need
# Consolidate all archives
# Backup it to a NAS that has ftp enabled
# Change user, pwd, ip
# Change remote path share/data/alpc/bck/
# Change local path /home/alain/tmp/
# Install lftp
# -------------------------------------------------------
dir="[$(date +%Y%m%d_%H%M%S)]/"

mkdir /home/alain/tmp/${dir}
tar czvf /home/alain/tmp/${dir}/dev_zip.tar.gz     /home/alain/dev_zip 2>/dev/null

# NAS
lftp -e "open -u user,pwd ftp://ip; mkdir share/data/alpc/bck/\"${dir}\" ; exit"
lftp -e "open -u user,pwd ftp://ip; put -O share/data/alpc/bck/\"${dir}\" /home/alain/tmp/\"${dir}\"/dev_zip.tar.gz ; exit"


