#!/bin/bash

# Script for installing Pulse Effects/Easyeffects and setting default preset
#
# Tested on:
#	-Ubuntu
#	-Fedora
#	-Manjaro
#   	-Linux Mint
#	-Zorin
set -e

# Automatically exit script on non-zero exit codes
# Report the command that failed
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap 'echo "Exit $? due to: \"$previous_command\""' ERR

# Exit if script is run as root
if [ "$EUID" -eq 0 ]; then echo "Please run as user"; exit 1; fi

# Set correct variables according to package manager
if apt install -h &>/dev/null; then
	app_type=pulse
	app_type_cap=Pulse
	pkg_mgr=apt
	folder_name=PulseEffects
elif dnf --version &>/dev/null; then
	app_type=easy
	app_type_cap=Easy
	pkg_mgr=dnf
	folder_name=easyeffects
elif pamac --version &>/dev/null; then
	app_type=easy
	app_type_cap=Easy
	pkg_mgr=pamac
	folder_name=easyeffects
fi
# Independant variables
audio_pci_id=$(lspci | grep "Audio device: Intel" | awk '{print $1}' | sed 's/:/_/')
speaker_id=alsa_output.pci-0000_$audio_pci_id.analog-stereo\:analog-output-speaker.json
headphones_id=alsa_output.pci-0000_$audio_pci_id.analog-stereo\:analog-output-headphones.json

installEffects() {
	# Catch for Manjaro, needs additional package
	if [[ $pkg_mgr == "pamac" ]] ; then 
		sudo $1 install "$app_type"effects manjaro-pipewire --no-confirm
	# Workaround for Ubuntu, settings aren't properly initialized on reboot
	# This installs a newer version of pulseeffects
	elif [[ $XDG_CURRENT_DESKTOP == "ubuntu:GNOME" ]] ; then
		if apt list --installed "$app_type"effects | grep pulse; then
			echo "$app_type effects already installed, skipping"
		else
			echo "deb http://nl.archive.ubuntu.com/ubuntu/ kinetic main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
			sudo $1 update
			sudo $1 install "$app_type"effects -y
			sudo sed '$d' /etc/apt/sources.list | sudo tee /etc/apt/sources.list.temp && sudo mv /etc/apt/sources.list.temp /etc/apt/sources.list
		fi
	# Normal case install method
	else 
		sudo $1 install "$app_type"effects -y
	fi
	echo "$folder_name installed"
}

createFolders() {
	# Create folders needed later, ~/.config/autostart usually already exists
	mkdir -p ~/.config/$1 &>/dev/null
	mkdir -p ~/.config/$1/output &>/dev/null
	mkdir -p ~/.config/$1/autoload &>/dev/null
	mkdir -p ~/.config/autostart &>/dev/null
	echo "Created config folders"
}

createAutostart() {
# Create an autostart entry to automatically apply the preset on log-in
### Not indented because of EOF rules
cat <<EOF > ~/.config/autostart/"$2"effects-service.desktop
[Desktop Entry]
Name=$1Effects
Comment=$1Effects Service
Exec=$2effects --gapplication-service
Icon=$2effects
StartupNotify=false
Terminal=false
Type=Application
EOF
echo "Created autostart file"
}

setPresetFile() {
	# Look for a preset file for the correct model/application and apply this instead of the default
	folder=./presets

	# Get current model
	model=$(sudo dmidecode | grep "Name:" | head -n 1)
	model=${model#*Name: }

	# Loop through the presets folder
	for file in $folder/*
	do
		# Check if the model + application combination exist
		if [ $file = $folder/$model\_$app_type.json ] ; then
			echo "Found specific preset for model"
			echo "Applying"
			# Set preset file to the file found
			preset_file=$file
			break
		else
			# Use default if no specific preset found
			preset_file=$folder/Default\_$app_type.json
		fi
	done
	# Copy preset file to preset folder in the pulse/easy effects config folder
	sudo cp $preset_file ~/.config/$folder_name/output/Default.json && echo "Copied $preset_file to ~/.config/$folder_name/output/Default.json"
	# Set Headphones_TYPE.json (empty config) as default for 3.5mm
	sudo cp $folder/Headphones_$app_type.json ~/.config/$folder_name/output/Headphones.json
	# Set rights to user
	sudo chown $USER ~/.config/$folder_name/output/*.json
	# Set Default as default for speakers and Headphones as default for the 3.5mm jack
	echo -e "{\n\t\"name\": \"Default\"\n}" > ~/.config/$folder_name/autoload/$speaker_id
	echo -e "{\n\t\"name\": \"Headphones\"\n}" > ~/.config/$folder_name/autoload/$headphones_id
	# Apply preset as the default selected preset
	#"$app_type"effects -l Default &>/dev/null || true
}

if [[ $pkg_mgr == "" ]] ; then
	# Catch for if $pkg_mgr isn't filled. This means the code won't get executed properly
	echo "Package Manager not one of the following:"
	echo "	-apt"
	echo "	-dnf"
	echo "	-pamac"
	echo -e "\n Stopping script."
	exit 1
else
	# Main install sequence
	installEffects "$pkg_mgr"
	createFolders "$folder_name"
	setPresetFile
	createAutostart $app_type_cap $app_type
fi

echo "Installation complete!"
echo "Please reboot your machine"
echo "You can safely remove this folder"
