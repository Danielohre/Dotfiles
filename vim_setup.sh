#!/bin/bash

case "$OSTYPE" in
    linux*) echo "LINUX";;
    msys*) echo "WINDOWS";;
esac

