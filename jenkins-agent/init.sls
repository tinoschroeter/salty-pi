awscli:
  pip.installed:
    - require:
      - pkg: python-pip

/tmp/bellsoft-jdk11.deb
  file.managed:
  - source: https://github.com/bell-sw/Liberica/releases/download/11.0.11%2B9/bellsoft-jdk11.0.11+9-linux-aarch64-full.deb

Install_JDK_11:

