#!/bin/bash

yes|ssh-keygen -N "" -t ed25519 -C "salt@salt-master.local" -f ./backuppc/id_ed25519

salt '*' state.apply
