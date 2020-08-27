#!/bin/bash
#
# SCRIPT:	unzip_batch.sh
# AUTHOR:	s7ntax
# DATE:		27-08-2020
# REV:		1.1.A
# PLATFORM:	Linux
#
# PURPOSE:	This script will unzip all zip files in pwd
#
for i in *.zip; do
    unzip "$i"
done
