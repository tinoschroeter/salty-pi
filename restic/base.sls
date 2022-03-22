#
# Create a restic user
#

restic-group:
  group.present:
    - name: restic

restic:
  user.present:
    - fullname: Restic Backup
    - shell: /bin/bash
    - home: /var/lib/restic
    - createhome: true
    - system: true
    - groups:
      - restic
    - require:
      - group: restic-group

#
# Install restic binary from github (the debian packages are quite outdated)
#

{% set version = 0.12.1 %}

download-restic:
  file.managed:
    - name: /var/tmp/restic{{ version }}_linux_{{ grains['osarch'] }}.bz2
    - source: https://github.com/restic/restic/releases/download/v{{ version }}/restic_{{ version }}_linux_{{ grains['osarch'] }}.bz2
    - skip_verify: true
    - user: root
    - group: root
    - mode: 0755

install-restic:
  cmd.run:
    - name: bunzip2 -k /var/tmp/restic_{{ version }}_linux_{{ grains['osarch'] }}.bz2 -c > restic && chmod 0700 restic 
    - cwd: /var/lib/restic
    - runas: restic
    - creates:
      - /var/lib/restic/restic
    - require:
      - file: download-restic

/var/lib/restic/.ssh/:
  file.directory:
    - user: restic
    - group: restic
    - mode: 0700
