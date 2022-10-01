update:
  cmd.run:
    - name: apt-get update

upgrade:
  cms.run:
    - name: apt-get dist-upgrade -y
