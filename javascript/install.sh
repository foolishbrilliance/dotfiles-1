#!/bin/sh

if test ! $(which jsc)
then
  echo "  Linking OSX's jsc for you."
  sudo ln -s -f /System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/jsc /usr/local/bin/jsc
fi
