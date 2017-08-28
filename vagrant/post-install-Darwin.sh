#!/bin/sh

if ! vagrant plugin list |grep vagrant-aws &>/dev/null; then
  vagrant plugin install vagrant-aws
fi

if ! vagrant box list |grep aws &>/dev/null; then
  echo 'Install dummy box'
  # This is broken as of 2017-08-28 with, will debug later when I need to:
  # ==> box: Box file was not detected as metadata. Adding it directly...
  # ==> box: Adding box 'dummy' (v0) for provider:
  #     box: Downloading: https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
  # An error occurred while downloading the remote file. The error
  # message, if any, is reproduced below. Please fix this error and try
  # again.
  #vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
fi
