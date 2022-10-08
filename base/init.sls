include:
{% if grains['osarch'] == "arm64" %}
  - base.packages
  - base.ssh
  - base.oh-my-zsh
{% endif %}
  - update
