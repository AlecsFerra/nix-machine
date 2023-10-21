#!/usr/bin/env bash

nixos-rebuild build-vm -I nixos-config=./nixos/configuration.nix
