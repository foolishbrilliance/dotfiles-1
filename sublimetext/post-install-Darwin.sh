#!/bin/sh
# Sync SublimeText2 settings per https://sublime.wbond.net/docs/syncing

echo "Configuring Dropbox sync for SublimeText2..."
SUBL_SETTINGS=~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User
DB_SETTINGS=~/Dropbox/Documents/Application\ Files/SublimeText/User 
# Check if:
# 1) SublimeText is installed
# 2) Dropbox settings have been synced
# 3) Sublime settings exist
# 4) That these links have not been created before
CHECKS_PASS=false
if test $(open -b com.sublimetext.2); then
  echo "SublimeText2 not installed. Exiting..."
elif [ ! -d "${DB_SETTINGS}" ]; then
  echo "${DB_SETTINGS} does not exist. Exiting..."
elif [ ! -d "${SUBL_SETTINGS}" ]; then
  echo "${SUBL_SETTINGS} does not exist. Exiting..."
elif [ -L "${SUBL_SETTINGS}" ]; then
  echo "${SUBL_SETTINGS} is already a symlink. Exiting..."
else
  CHECKS_PASS=true
fi

if [ $CHECKS_PASS == true ]; then
  echo "Configuring Dropbox sync for SublimeText2. Backing up current settings to ${SUBL_SETTINGS}.orig"
  mv "${SUBL_SETTINGS}" "${SUBL_SETTINGS}.orig"
  ln -s "${DB_SETTINGS}" "${SUBL_SETTINGS}"
else
  echo "Did nothing."
fi
