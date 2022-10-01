backuppcInstall:
  pkg.installed:
    - pkgs:
      - samba-common
      - prometheus-node-exporter
      - samba
      - smbclient
      - libfile-rsyncp-perl
      - backuppc

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
