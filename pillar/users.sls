users:
  ubuntu:
    groups:
      - ssh
    password: "*" # http://arlimus.github.io/articles/usepam/
    shell: /usr/bin/zsh
    ssh_auth_sources:
      - salt://files/ssh_keys/ThinkCentre-M91p.pub
      - salt://files/ssh_keys/ThinkPad-T540p.pub
      - salt://files/ssh_keys/XPS-15-9510.pub
    sudouser: True
    sudo_rules:
      - "ALL=(root) NOPASSWD:ALL"
