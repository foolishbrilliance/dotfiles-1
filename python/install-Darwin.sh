#!/bin/sh

if test ! $(which pip)
then
  echo "  Installing python/pip for you."
  brew install python       # pip should be installed by brew in python install
  pip install --upgrade pip # Update pip
fi

