#!/bin/bash
#
# SCRIPT:	scanclam.sh
# AUTHOR:	s7ntax
# DATE:		12-09-2020
# REV:		1.1.B
# PLATFORM:	Linux
#
# PURPOSE:	This script will update the virus definitions and scan the 
#		directory or files specified using clamav. Log files will be
#		placed in /home/$USER/clamav/log/ and this directory will be
#		created if it doesn't exist. If quarantine is selected then
#		infected files will placed in /home/$USER/clamav/quarantine
#		and this directory will also be created if it doesn't exist.
#		There is also an option to remove infected files but this
#		should be used with caution. There is also an option to limit
#		the use of system resources used by clamav while scanning.
#
# Requesting user password for sudo

sudo sleep 1
echo ""

# Creating directories if don't exist
mkdir -p ~/documents/sysinfo/clamscan/

# Updating virus definitions

# Stop clamav-freshclam.service if running and restart after update

service=$(systemctl is-active clamav-freshclam.service)

if [ "$service" = inactive ]
then
	echo -e "\e[30;48;5;10m***** UPDATING VIRUS DEFINITIONS *****\e[0m"
	echo ""
	sudo freshclam
	echo ""
else
	sudo systemctl stop clamav-freshclam.service
	echo -e "\e[30;48;5;10m***** UPDATING VIRUS DEFINITIONS *****\e[0m"
	echo ""
	sudo freshclam
	echo ""
	sudo systemctl start clamav-freshclam.service
fi

# Ask user for the directory to scan

echo -n "Make a selection or type path ( / = system) ( h = home ) ( p = pwd ) ( x = exit ) > "
read -r dirscan

# If x

if [[ "$dirscan" =~ ^([xX])$ ]]
then
	exit
else

# Ask to quarantine infected files

echo ""
echo -n "Quarantine infected files (y/n default n) (remove type 'remove' use with caution!) > "
read -r quarantine

# Ask to save resources

echo ""
echo -n "Would you like to conserve system resources whilst scanning (y/n) > "
read -r resources

# Quarantine yes

if [[ "$quarantine" =~ ^([yY])$ ]]
then
mkdir -p /home/"$USER"/clamav/quarantine/

# Scanning directory recursive

# If resources

if [[ "$resources" =~ ^([yY][eE][sS]|[yY])$ ]]
then

if [ "$dirscan" = / ]
then
        sudo nice -n 15 clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
        exit
elif [ "$dirscan" = h ]
then
                sudo nice -n 15 clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ ~/ -l ~/documents/sysinfo/clamscan/log
                exit
        elif [ "$dirscan" = p ]
        then
                        sudo nice -n 15 clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ . -l ~/documents/sysinfo/clamscan/log
                elif [ "$dirscan" = x ]
                then
                        exit
                else
			if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
                        sudo nice -n 15 clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ "$dirscan" -l ~/documents/sysinfo/clamscan/log
                        exit
                fi
                fi

else

# Scanning directory recursive

if [ "$dirscan" = / ]
then
        sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
        exit
elif [ "$dirscan" = h ]
then
                sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ ~/ -l ~/documents/sysinfo/clamscan/log
                exit
        elif [ "$dirscan" = p ]
        then
                        sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ . -l ~/documents/sysinfo/clamscan/log
                elif [ "$dirscan" = x ]
                then
                        exit
                else
			if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
                        sudo clamscan --recursive=yes --infected --move=/home/"$USER"/clamav/quarantine/ "$dirscan" -l ~/documents/sysinfo/clamscan/log
                        exit
                fi
        fi
fi

elif [ "$quarantine" = remove ]
then

# Scanning directory recursive

# If resources

if [[ "$resources" =~ ^([yY][eE][sS]|[yY])$ ]]
then

if [ "$dirscan" = / ]
then
        sudo nice -n 15 clamscan --recursive=yes --infected --remove --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
        exit
elif [ "$dirscan" = h ]
then
                sudo nice -n 15 clamscan --recursive=yes --infected --remove ~/ -l ~/documents/sysinfo/clamscan/log
                exit
        elif [ "$dirscan" = p ]
        then
                        sudo nice -n 15 clamscan --recursive=yes --infected --remove . -l ~/documents/sysinfo/clamscan/log
                elif [ "$dirscan" = x ]
                then
                        exit
                else
			if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
                        sudo nice -n 15 clamscan --recursive=yes --infected --remove "$dirscan" -l ~/documents/sysinfo/clamscan/log
                        exit
                fi
        fi

else

# Scanning directory recursive

if [ "$dirscan" = / ]
then
        sudo clamscan --recursive=yes --infected --remove --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
        exit
elif [ "$dirscan" = h ]
then
                sudo clamscan --recursive=yes --infected --remove ~/ -l ~/documents/sysinfo/clamscan/log
                exit
        elif [ "$dirscan" = p ]
        then
                        sudo clamscan --recursive=yes --infected --remove . -l ~/documents/sysinfo/clamscan/log
                elif [ "$dirscan" = x ]
                then
                        exit
                else
			if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
                        sudo clamscan --recursive=yes --infected --remove "$dirscan" -l ~/documents/sysinfo/clamscan/log
                        exit
                fi
        fi
fi

else
	
# Scanning directory recursive

# If resources

if [[ "$resources" =~ ^([yY][eE][sS]|[yY])$ ]]
then

if [ "$dirscan" = / ]
then
        sudo nice -n 15 clamscan --recursive=yes --infected --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
        exit
elif [ "$dirscan" = h ]
then
                sudo nice -n 15 clamscan --recursive=yes --infected ~/ -l ~/documents/sysinfo/clamscan/log
                exit
        elif [ "$dirscan" = p ]
        then
                        sudo nice -n 15 clamscan --recursive=yes --infected . -l ~/documents/sysinfo/clamscan/log
                elif [ "$dirscan" = x ]
                then
                        exit
                else
			if [ ! -d "$dirscan" ]; then
			echo "Directory does not exist."
			exit
		else
                        sudo nice -n 15 clamscan --recursive=yes --infected "$dirscan" -l ~/documents/sysinfo/clamscan/log
                        exit
                fi
        fi

else

# Scanning directory recursive

if [ "$dirscan" = / ]
then
        sudo clamscan --recursive=yes --infected --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' / -l ~/documents/sysinfo/clamscan/log
        exit
elif [ "$dirscan" = h ]
then
                sudo clamscan --recursive=yes --infected ~/ -l ~/documents/sysinfo/clamscan/log
                exit
        elif [ "$dirscan" = p ]
        then
                        sudo clamscan --recursive=yes --infected . -l ~/documents/sysinfo/clamscan/log
                elif [ "$dirscan" = x ]
                then
                        exit
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
fi
fi
