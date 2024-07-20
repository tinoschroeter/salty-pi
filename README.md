# Salty PI

[![k3s](https://img.shields.io/badge/run%20on%20-Raspberry%20Pi-red)](https://github.com/tinoschroeter/k8s.homelab)
![last-commit](https://img.shields.io/github/last-commit/tinoschroeter/salty-pi.svg?style=flat)

[![saltstack](https://img.shields.io/badge/thorstenkramm%20-gitbook%20saltstack-blue)](https://thorstenkramm.gitbook.io/saltstack/)

![image](https://raw.githubusercontent.com/tinoschroeter/salty-pi/master/docs/salty.jpg)

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
> /srv/salt

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
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=wheel \
     -d fun=key.list_all
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
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=local \
     -d tgt='*' \
     -d fun=grains.items
```

```shell
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=local \
     -d tgt='minion1' \
     -d fun=pillar.items
```

```shell
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=local \
     -d tgt='*' \
     -d fun=state.apply
```

```shell
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=local -d tgt='worker-node0*' \
     -d fun=state.apply \
     -d '["arg=base"]'
```

```shell
curl -sSk http://localhost:8000 \
     -H "Accept: application/json" \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d tgt='*' \
     -d fun=test.ping \
     -d client=local_async
```

```shell
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=runner \
     -d fun=jobs.list_jobs
```

```shell
curl -sSk http://localhost:8000/jobs/20240720124257971546
     -H "Accept: application/json"
     -H "X-Auth-Token: $(cat /tmp/token)"
```

```shell
curl -sSk http://localhost:8000/keys \
     -H 'Accept: application/x-yaml' \
     -H "X-Auth-Token: $(cat /tmp/token)"
```

```shell
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=runner \
     -d fun=jobs.list_jobs
```

```shell
curl -sSk http://localhost:8000 \
     -H 'Accept: application/json' \
     -H "X-Auth-Token: $(cat /tmp/token)" \
     -d client=runner \
     -d fun=manage.status
```

```shell
# fix Trailing whitespace in vim

:%s/\s\+$//e
```
