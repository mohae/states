{% for user, args in pillar.get('users', {}).items() %}

{% for group in args.get('groups', []) %}
{{ group }}:
    group:
        - present
{% endfor %}

{{ user }}:
    group:
        - present
    user.present:
        - home: {{ args.get('home', '/home/%s' % user) }}
        - createhome: True
        - shell: {{ args.get('shell', '/bin/bash') }}
        {% if 'uid' in args %}
        - uid: {{ args.get('uid') }}
        {% endif %}
        - gid_from_name: True
        {% if 'fullname' in args %}
        - fullname: {{ args.get('fullname') }}
        {% endif %}
        - groups:
            - {{ user }}
            {% for group in args.get('groups', []) %}
            - {{ group }}
            {% endfor %}
        - require:
            - group: {{ user }}
            {% for group in args.get('groups', []) %}
            - group: {{ group }}
            {% endfor %}

{% if 'ssh_auth' in args %}
{{ args.get('home', '/home/%s' % user) }}/.ssh:
    file.directory:
        - user: {{ user }}
        - group: {{ user }}
        - makedirs: True
        - mode: 700
        - require:
            - user: {{ user }}
            - group: {{ user }}
            {% for group in args.get('groups', []) %}
            - group: {{ group }}
            {% endfor %}

{{ args.get('home', '/home/%s' % user) }}/.ssh/authorized_keys:
    file.managed:
        - user: {{ user }}
        - group: {{ user }}
        - mode: 600
        - require:
            - file: {{ args.get('home', '/home/%s' % user) }}/.ssh

{% for key in args.get('ssh_auth', []) %}
{{ key }}:
    ssh_auth.present:
        - user: {{ user }}
        - require:
            - file: {{ args.get('home', '/home/%s' % user) }}/.ssh/authorized_keys
{% endfor %}
{% endif %}

{% endfor %}
