
rsync:
  pkg.installed

backup_keys:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://backuppc/id_ed25519.pub
    - user: root
    - group: root
    - mode: 0600
    - makedirs: true
