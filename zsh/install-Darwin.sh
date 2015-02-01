#!/bin/sh

if [[ ! -n $(brew ls --versions zsh) ]]; then
  echo "  Installing zsh for you."
  brew install zsh
fi
