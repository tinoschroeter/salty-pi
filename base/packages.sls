packages:
  pkg.installed:
    - pkgs:
{% if grains['osarch'] == "arm64" %}
        - nodejs
{% endif %}
        - curl
        - dnsutils
        - dstat
        - git
        - htop
        - iotop
        - jq
        - neofetch
        - nfs-common
        - python3-pip
        - ssh
        - sysstat
        - vim
        - zsh

# Don't install prometheus-node-exporter on Kubernetes hosts.

{%- if not salt['file.directory_exists']('/etc/rancher/k3s') %}
prometheus-node-exporter:
  pkg.installed:
    - pkgs:
      - prometheus-node-exporter
{%- endif %}
