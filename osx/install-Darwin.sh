#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
  exit 1
fi

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

# The brew handles some installs, but there may still be updates and installables in the Mac App Store. There's a nifty command line interface to it that we can use to just install everything, so yeah, let's do that.
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a

echo ''
echo '  All installed!'
