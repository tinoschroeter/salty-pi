include:
  - .base

authorized_keys:
  file.managed:
    - name: /var/lib/restic/.ssh/authorized_keys
    - source: salt://restic/id_ed25519.pub
    - user: restic
    - group: restic
    - mode: "0600"
