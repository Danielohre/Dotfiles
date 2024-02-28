#!/bin/bash

case "$OSTYPE" in
    linux*) 
	echo "LINUX"
	cp init.vim ~/.config/nvim/
	;;
    msys*)
	echo "WINDOWS"
	cp init.vim ~/AppData/Local/nvim/
	;;
esac

