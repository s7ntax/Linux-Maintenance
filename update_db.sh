#!/bin/bash
#
# SCRIPT:	update_db.sh
# AUTHOR:	s7ntax
# DATE:		20-02-2016
# REV:		1.1.A
# PLATFORM:	Linux
#
# PURPOSE:	This script will update the local file database, alert
#		when the file system usage surpasses a defined limit,
#		display the hostname information, display file system usage,
#		display free and used memory in the system, display system
#		uptime and load, display logged in users and display top 
#		5 processes as far as memory usage is concerned.
#

# Update local file database:

echo -e "\e[30;48;5;10m***** UPDATING LOCAL FILE DATABASE *****\e[0m"
sudo updatedb
if [ $? == 0 ]; then
echo "The local file database was updated correctly."
else
echo "The local file database was not updated correctly."
fi
echo ""

# -Alert when file system usage surpasses a defined limit 

THRESHOLD=80
while read line; do

# This variable stores the file system path as a string

FILESYSTEM=$(echo $line | awk '{print $1}')

# This variable stores the use percentage (XX%)

PERCENTAGE=$(echo $line | awk '{print $5}')

# Use percentage without the % sign.

USAGE=${PERCENTAGE%?}
if [ $USAGE -gt $THRESHOLD ]; then
echo -e "\e[30;48;5;10m***** FILE SYSTEM USAGE *****\e[0m"
echo "The remaining available space in $FILESYSTEM is critically low. Used: $PERCENTAGE"
fi
done < <(df -h --total | grep -vi filesystem)

# -Hostname information:

echo -e "\e[30;48;5;10m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""

# -File system disk space usage:

echo -e "\e[30;48;5;10m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
df -h
echo ""

# -Free and used memory in the system:

echo -e "\e[30;48;5;10m***** FREE AND USED MEMORY *****\e[0m"
free
echo ""

# -System uptime and load:

echo -e "\e[30;48;5;10m***** SYSTEM UPTIME AND LOAD *****\e[0m"
uptime
echo ""

# -Logged-in users:

echo -e "\e[30;48;5;10m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
who
echo ""

# -Top 5 processes as far as memory usage is concerned

echo -e "\e[30;48;5;10m***** TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""
echo -e "\e[1;32mDone.\e[0m"
