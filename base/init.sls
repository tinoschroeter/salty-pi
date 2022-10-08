include:
{% if grains['osarch'] == "arm64" %}
  - base.oh-my-zsh
  - base.ssh
{% endif %}
  - base.packages
  - update
