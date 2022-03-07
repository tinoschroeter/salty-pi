{% for user in pillar['oh-my-zsh']['users'] %}

install-oh-my-zsh:
  cmd.run:
    - name: sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    - creates: /home/{{ user }}/.oh-my-zsh
    - runas: {{ user }}
    - env:
      - HOME: /home/{{ user }}

{% endfor %}
