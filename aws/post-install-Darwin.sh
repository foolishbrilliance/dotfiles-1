#!/bin/sh

if test ! $(which aws)
then
  echo "  Installing aws-cli for you."
  sudo pip install awscli
fi
