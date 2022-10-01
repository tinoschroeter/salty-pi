# Salty PI

[![Build Status](https://jenkins.tino.sh/buildStatus/icon?job=salty-pi%2Fmaster)](https://jenkins.tino.sh/job/salty-pi/job/master/)
[![k3s](https://img.shields.io/badge/run%20on%20-Raspberry%20Pi-red)](https://github.com/tinoschroeter/k8s.homelab)
![](https://img.shields.io/github/last-commit/tinoschroeter/salty-pi.svg?style=flat)


[![saltstack](https://img.shields.io/badge/thorstenkramm%20-gitbook%20saltstack-blue)](https://thorstenkramm.gitbook.io/saltstack/)


![](https://raw.githubusercontent.com/tinoschroeter/salty-pi/master/docs/salty.jpg)

## install minion

```shell
curl -L https://bootstrap.saltproject.io -o install_salt.sh

# install master + minion
sudo sh install_salt.sh -P -M

# install minion
sudo sh install_salt.sh -P
```

```shell
salt-key -L      # list client requests
salt-key -a host # Accept the specified public key
salt-key -A      # Accept all pending keys.
```

```shell
salt '*' test.ping # test connection
```
## Salt states 

> default salt storage 
/srv/salt

## Salt API

```shell
apt install salt-api

cat /etc/salt/master.d/api.conf
external_auth:
  pam:
    salt-api:
      - .*
      - '@wheel'
      - '@runner'

rest_cherrypy:
  host: 127.0.0.1 # omit to listen on all IPs
  port: 8000
  disable_ssl: true
  debug: true

systemctl restart salt-master.service
systemctl restart salt-api.service

useradd -m -d /var/lib/salt-api -r -s /usr/sbin/nologin salt-api
passwd salt-api
```

### API Examples

```shell
curl -sS http://localhost:8000/login \
  -H 'Accept: application/x-yaml' \
  -d username=salt-api \
  -d password=123ab \
  -d eauth=pam|grep token|awk '{print $2}'>/tmp/token
```

```shell
curl -sSk http://localhost:8000 \
  -H 'Accept: application/x-yaml' \
  -H "X-Auth-Token: $(cat /tmp/token)" \
  -d client=local \
  -d tgt='*' \
  -d fun=test.ping
```

```shell
# fix Trailing whitespace in vim

:%s/\s\+$//e
```
