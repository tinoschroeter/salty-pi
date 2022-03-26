# Salty PI

[![Build Status](https://jenkins.tino.sh/buildStatus/icon?job=salty-pi%2Fmaster)](https://jenkins.tino.sh/job/salty-pi/job/master/)
[![k3s](https://img.shields.io/badge/run%20on%20-Raspberry%20Pi-red)](https://github.com/tinoschroeter/k8s.homelab)
![](https://img.shields.io/github/last-commit/tinoschroeter/salty-pi.svg?style=flat)

## install minion

```shell
curl -L https://bootstrap.saltproject.io -o install_salt.sh
sudo sh install_salt.sh -P
```

```shell
# fix Trailing whitespace in vim

:%s/\s\+$//e
```
