{% set user = salt['grains.filter_by']({
    'Ubuntu': 'ubuntu',
    'Debian': 'pi',
    }, grain='os') %}

authorized_keys:
  file.managed:
    - name: /home/{{ user }}/.ssh/authorized_keys
    - source: salt://files/ssh_keys/authorized_keys
    - user: {{ user }}
    - mode: "0600"
