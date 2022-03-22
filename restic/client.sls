include:
  - .base

priv-key:
  file.managed:
    - name: /var/lib/restic/.ssh/id_ed25519
    - source: salt://restic/id_ed25519
    - user: restic
    - group: restic
    - mode: 0600

libcap2-bin:
  pkg.installed: []
# Allow restic do read alls files without root-rights
set-cap:
  cmd.run: 
    - name: setcap cap_dac_read_search=+ep /var/lib/restic/restic
    - unless: getcap /var/lib/restic/restic|grep -q cap_dac_read_search+ep
    - require:
      - pkg: libcap2-bin

#
# Create a SSH Client config
#
ssh-client-conf:
  file.managed:
    - name: /var/lib/restic/.ssh/config
    - contents: |
        HashKnownHosts no
        Host restic-server
            StrictHostKeyChecking No
            Hostname {{ pillar['restic_server'] }}
            User restic
            Port 22

#
# Initialize the remote repository where the backups will be stored
#
password-create:
  cmd.run:
    - name: openssl rand -hex 20 > .restic-password && chmod 0600 .restic-password
    - cwd: /var/lib/restic
    - runas: restic
    - creates:
      - /var/lib/restic/.restic-password

repo-init:
  cmd.run:
    - name: ./restic -p .restic-password -r sftp:restic-server:./{{ grains['id'] }} init > .restic-state
    - runas: restic
    - cwd: /var/lib/restic
    - unless: grep -q "created restic repository" .restic-state
    - require:
      - cmd: password-create

#
# Backup the genrated password to the salt master
# to restore if the machine gets completely lost
#
password-backup:
  module.run:
    - name: cp.push
    - path: /var/lib/restic/.restic-password

/var/lib/restic/data:
  file.directory:
    - user: restic
    - group: restic
    - mode: 0700

/var/lib/restic/run.sh:
  file.managed:
    - user: restic
    - group: restic
    - mode: 0700
    - contents: |
        #!/bin/bash
        # Export list of installed packages
        dpkg --get-selections > /var/lib/restic/data/dpkg-get-selections.txt
        cd /var/lib/restic
        # Do the backup
        ./restic -p .restic-password -r sftp:restic-server:./{{ grains['id'] }} backup --files-from ./files_to_backup
        # Remove old backups
        ./restic -p .restic-password -r sftp:restic-server:./{{ grains['id'] }} forget --keep-last 7 --prune

#
# Create the list of files or folders to backup
#
{% set files = ['/etc','/root','/var/backups','/var/lib/restic/data', '/home'] + salt['pillar.get']('backup:include',[]) %}
/var/lib/restic/files_to_backup:
  file.managed:
    - user: restic
    - groupd: restic
    - mode: 0600
    - contents: |
        {% for file in files -%}
        {{ file }}
        {% endfor %}

#
# Create the cronjob
#
/var/lib/restic/run.sh > /var/lib/restic/last.log:
  cron.present:
    - user: restic
    - minute: '*/5'
    - identifier: RESTIC
    - require:
      - file: /var/lib/restic/files_to_backup
      - file: /var/lib/restic/run.sh
