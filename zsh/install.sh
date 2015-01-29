#!/bin/sh

if [[ ! -n $(brew ls --versions zsh) ]]; then
  echo "  Installing zsh for you."
  brew install zsh
fi

# install oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  echo "  Installing oh-my-zsh for you."
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 
fi