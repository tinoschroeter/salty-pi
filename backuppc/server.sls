/var/lib/backuppc:
  mount.mounted:
    - device: UUID=976dfb92-7ce9-428c-ab63-002ad1dad1f6
    - fstype: btrfs
    - opts: defaults
    - dump: 0
    - pass_num: 2
    - persist: True
    - mkmnt: True

backuppcInstall:
  pkg.installed:
    - pkgs:
      - samba-common
      - prometheus-node-exporter
      - sponge
      - samba
      - smbclient
      #- backuppc

priv-key:
  file.managed:
    - name: /var/lib/backuppc/.ssh/id_ed25519
    - source: salt://backuppc/id_ed25519
    - user: backuppc
    - group: backuppc
    - mode: "0600"
    - makedirs: true
    - require:
      - pkg: backuppcInstall

ssh-config:
  file.managed:
    - name: /var/lib/backuppc/.ssh/config
    - source: salt://backuppc/file/ssh_config
    - user: backuppc
    - group: backuppc
    - mode: "0400"
    - makedirs: true
    - require:
      - pkg: backuppcInstall

backuppc.conf:
  file.managed:
    - name: /etc/apache2/conf-enabled/backuppc.conf
    - source: salt://backuppc/file/backuppc.conf
    - user: backuppc
    - group: backuppc
    - mode: "0660"
    - require:
      - pkg: backuppcInstall

config.pl:
  file.managed:
    - name: /etc/backuppc/config.pl
    - source: salt://backuppc/file/config.pl
    - user: backuppc
    - group: backuppc
    - mode: "0660"
    - require:
      - pkg: backuppcInstall

hosts:
  file.managed:
    - name: /etc/backuppc/hosts
    - source: salt://backuppc/hosts
    - user: backuppc
    - group: backuppc
    - mode: "0660"
    - require:
      - pkg: backuppcInstall

backuppc_exporter:
  file.managed:
    - name: /opt/backuppc_exporter
    - source: salt://backuppc/backuppc_exporter
    - user: root
    - group: root
    - mode: "0760"
    - require:
      - pkg: backuppcInstall

/opt/backuppc_exporter | sponge /var/lib/prometheus/node-exporter/backuppc.prom:
  cron.present:
    - user: root
    - minute: "*/10"

# https://github.com/HanGhoul/BackupPC-v3-BetterCSS
better_css:
  file.managed:
    - name: /usr/share/backuppc/image/BackupPC_bttr.css
    - source: salt://backuppc/file/BackupPC_bttr.css
    - user: root
    - group: root
    - mode: "0644"
    - makedirs: true
    - require:
      - pkg: backuppcInstall

backuppc:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/conf-enabled/backuppc.conf

apache2:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/conf-enabled/backuppc.conf
