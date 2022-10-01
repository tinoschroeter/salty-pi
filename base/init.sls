{% if grains['osarch'] == "arm64" %}
include:
  - base.packages
  - base.ssh
  - base.oh-my-zsh
  - update
{% endif %}
