#!/bin/bash


userPath=$(echo $(wslvar USERPROFILE) | sed 's/\\/\//g') # Create windows style path to user
roamingFolder=$(wslpath -u "$(wslvar USERPROFILE)"/AppData/Roaming) # Create unix style path to Roaming
alacrittyFolder=$roamingFolder/alacritty #Create unix style path to where alacritty config should be stored

if ! [ -f $alacrittyFolder/alacritty.toml ]; then
	mkdir -p $alacrittyFolder
	touch $alacrittyFolder/alacritty.toml

	cp custom.toml $alacrittyFolder/

	# Add necessary lines to config.
	# Set working directory
	# Import common configurations via custom.toml
	echo [general] >> $alacrittyFolder/alacritty.toml
	echo working_directory = \"$userPath\" >> $alacrittyFolder/alacritty.toml
	echo import = [ >> $alacrittyFolder/alacritty.toml
	echo \"custom.toml\" >> $alacrittyFolder/alacritty.toml
	echo ] >> $alacrittyFolder/alacritty.toml
fi

echo Installing alacritty via winget
/mnt/c/Windows/System32/cmd.exe /c winget install -e --id Alacritty.Alacritty

