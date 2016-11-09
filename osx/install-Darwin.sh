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

# Required for other install.sh scripts
install_homebrew () {
  info 'install homebrew'
  if ! command -v brew >/dev/null 2>&1
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
    brew doctor
    success 'homebrew installed'
  else
    success 'skipping. homebrew already installed'
  fi
}

install_homebrew

echo ''
echo '  All installed!'
