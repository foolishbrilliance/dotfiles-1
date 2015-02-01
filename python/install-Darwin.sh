#!/bin/sh

if test ! $(which pip)
then
  echo "  Installing jsc for you."
  sudo easy_install pip
  pip install virtualenv
fi

