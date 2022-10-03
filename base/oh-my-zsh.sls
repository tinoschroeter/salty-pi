{% set user = salt['grains.filter_by']({
    'Ubuntu': 'ubuntu',
    'Debian': 'pi',
    }, grain='os') %}

install-oh-my-zsh:
  cmd.run:
    - name: sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    - creates: /home/{{ user }}/.oh-my-zsh
    - runas: {{ user }}
    - env:
      - HOME: /home/{{ user }}
