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
        - nodejs

# Don't install prometheus-node-exporter on Kubernetes hosts.

{%- if not salt['file.directory_exists']('/etc/rancher/k3s') %}
prometheus-node-exporter:
  pkg.installed:
    - pkgs:
      - prometheus-node-exporter
{%- endif %}
