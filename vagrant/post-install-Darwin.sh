#!/bin/sh

if ! vagrant plugin list |grep vagrant-aws &>/dev/null; then
  vagrant plugin install vagrant-aws
fi

if ! vagrant box list |grep aws &>/dev/null; then
  vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
fi