#!/bin/sh

if test ! $(which pip3)
then
  echo "  Installing python/pip for you."
  brew install python       # pip should be installed by brew in python install
fi
