#!/usr/bin/env bash

OWNER=$(whoami)

sudo rsync -a --delete /etc/nixos/ ./nixos/
sudo chown "$OWNER" -R ./nixos
