#!/bin/bash
#
# SCRIPT:	aptupg.sh
# AUTHOR:	s7ntax
# DATE:		26-08-2020
# REV:		1.1.A
# PLATFORM:	Linux / apt package manager
#
# PURPOSE:	This script will update the repository and all installed packages
# 		remove unused (orphan) packages, write a list of installed packages to
# 		file, check for broken symlinks, check for failed systemd services and
# 		display journalctl log.
#

# Update pacman repository and update packages

echo -e "\e[30;48;5;10m***** UPDATING REPOSITORY AND PACKAGES *****\e[0m"
sudo apt-get update && sudo apt-get dist-upgrade
echo -e "\e[1;10mDone.\e[0m"
echo ""

# Remove orphan packages

echo -e "\e[30;48;5;10m***** REMOVING UNUSED PACKAGES (ORPHANS) *****\e[0m"
sudo apt-get autoremove && sudo apt-get clean
echo -e "\e[1;10mDone.\e[0m"
echo ""

# Writing installed package lists to file: ~/Documents/Sysinfo/

echo -e "\e[30;48;5;10m***** WRITING INSTALLED PACKAGE LISTS TO FILE *****\e[0m"
sudo apt list --installed >| ~/documents/sysinfo/packagesQn.txt
echo -e "\e[1;10mDone.\e[0m"
echo ""

# Check for broken symlinks

echo -e "\e[30;48;5;10m***** CHECKING FOR BROKEN SYMLINKS *****\e[0m"
find . -type l -! -exec test -e {} \; -print
echo -e "\e[1;10mDone.\e[0m"
echo ""

# Display active failed systemd services

echo -e "\e[30;48;5;10m***** FAILED ACTIVE SYSTEMD SERVICES *****\e[0m"
systemctl --failed
echo ""

# Display failed systemd services including inactive

echo -e "\e[30;48;5;10m***** ALL FAILED SYSTEMD SERVICES *****\e[0m"
systemctl --failed --all
echo ""

# Display journalctl log

echo -e "\e[30;48;5;10m***** JOURNALCTL LOG *****\e[0m"
journalctl -p 3 -xb
echo ""
echo -e "\e[1;10mDone.\e[0m"
