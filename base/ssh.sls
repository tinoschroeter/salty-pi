authorized_keys:
  file.managed:
    - name: /home/ubuntu/.ssh/authorized_keys
    - source: salt://files/ssh_keys/authorized_keys
    - user: ubuntu
    - mode: "0600"
