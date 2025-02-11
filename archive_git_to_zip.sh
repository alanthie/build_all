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


