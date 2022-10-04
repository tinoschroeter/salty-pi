packages:
  pkg.installed:
    - pkgs:
        - ssh
        - htop
        - git
        - jq
        - vim
        - zsh
        - dstat
        - curl
        - neofetch
        - dnsutils
        - sysstat
        - iotop
        - python3-pip
        - nfs-common
        - prometheus-node-exporter
        - nodejs

# Don't install prometheus-node-exporter on Kubernetes hosts.

{%- if not salt['file.directory_exists']('/etc/rancher/k3s') %}
packages:
  pkg.installed:
    - pkgs:
      - prometheus-node-exporter
{%- endif %}
