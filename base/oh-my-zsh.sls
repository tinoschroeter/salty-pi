install-oh-my-zsh:
  cmd.run:
    - name: sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    - creates: /home/ubuntu/.oh-my-zsh
    - runas: ubuntu
    - env:
      - HOME: /home/ubuntu

