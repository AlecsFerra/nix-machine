#!/usr/bin/env bash

sudo rsync -a --delete ./nixos/ /etc/nixos/
sudo chown root -R /etc/nixos
