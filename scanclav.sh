#!/bin/bash
#
# SCRIPT:	scanclam.sh
# AUTHOR:	s7ntax
# DATE:		27-08-2020
# REV:		1.1.A
# PLATFORM:	Linux
#
# PURPOSE:	This script will update the virus definitions and scan the
#		directory or files specified using clamav. Log files will be
#		placed in /home/$USER/clamav/log/ and this directory will be
#		created if it doesn't exist. If quarantine is selected then
#		infected files will placed in /home/$USER/clamav/quarantine
#		and this directory will also be created if it doesn't exist.
#		There is also an option to remove infected files but this
#		should be used with caution.
#
# Requesting user password for sudo
#
sudo sleep 1
echo ""
#
# Updating virus definitions
#
echo -e "\e[30;48;5;10m***** UPDATING VIRUS DEFINITIONS *****\e[0m"
echo ""
sudo freshclam
mkdir -p ~/documents/sysinfo/clamscan/
echo ""
#
# Ask user for the directory to scan
#
echo "Make a selection or type path ( // = partial system ) ( / = full system ) ( h = home ) ( p = pwd ) ( x = exit )"
echo -n "> "
read -e -r dirscan
if [ "$dirscan" = x ]
	then
	exit
else
echo ""
echo "Quarantine infected files (y/n default n) (remove type 'remove' use with caution!)"
echo -n "> "
read -r quarantine
fi
#
# Scanning directory or file input by user
#
# Quarantine yes
#
if [ "$quarantine" = y ]
then
	mkdir -p /home/"$USER"/clamav/quarantine/
	if [ "$dirscan" = // ]
	then
		sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
		exit
		elif [ "$dirscan" = / ]
	then
		sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ / -l ~/documents/sysinfo/clamscan/log
		exit
	elif [ "$dirscan" = h ]
	then
		sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ ~/ -l ~/documents/sysinfo/clamscan/log
		exit
	elif [ "$dirscan" = p ]
	then
		sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ . -l ~/documents/sysinfo/clamscan/log
	else
		if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
			sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ "$dirscan" -l ~/documents/sysinfo/clamscan/log
			exit
		fi
	fi
#
# Remove infected files
#
elif [ "$quarantine" = remove ]
then
	if [ "$dirscan" = / ]
	then
		sudo clamscan --recursive=yes --infected --remove --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
		exit
		elif [ "$dirscan" = / ]
	then
		sudo clamscan --recursive=yes --infected --remove / -l ~/documents/sysinfo/clamscan/log
		exit
	elif [ "$dirscan" = h ]
	then
		sudo clamscan --recursive=yes --infected --remove ~/ -l ~/documents/sysinfo/clamscan/log
		exit
	elif [ "$dirscan" = p ]
	then
		sudo clamscan --recursive=yes --infected --remove . -l ~/documents/sysinfo/clamscan/log
	else
		if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
			sudo clamscan --recursive=yes --infected --remove "$dirscan" -l ~/documents/sysinfo/clamscan/log
			exit
		fi
	fi
else
#
# Quarantine no
#
	if [ "$dirscan" = / ]
	then
		sudo clamscan --recursive=yes --infected --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
		exit
		elif [ "$dirscan" = / ]
	then
		sudo clamscan --recursive=yes --infected / -l ~/documents/sysinfo/clamscan/log
		exit
	elif [ "$dirscan" = h ]
	then
		sudo clamscan --recursive=yes --infected ~/ -l ~/documents/sysinfo/clamscan/log
		exit
	elif [ "$dirscan" = p ]
	then
		sudo clamscan --recursive=yes --infected . -l ~/documents/sysinfo/clamscan/log
	else
		if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
			sudo clamscan --recursive=yes --infected "$dirscan" -l ~/documents/sysinfo/clamscan/log
			exit
		fi
	fi
fi
