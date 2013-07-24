nodejs:
    pkgrepo.managed:
        - ppa: chris-lea/node.js
        - require_in:
            - pkg: nodejs
    pkg:
        - installed

{% for package in pillar.get('npm', []) %}
{{ package }}:
    npm.installed:
        - require:
            - pkg: nodejs
{% endfor %}
