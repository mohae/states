redis-server:
    pkgrepo.managed:
        - ppa: chris-lea/redis-server
        - require_in:
            - pkg: redis-server
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/redis/common.conf
        - reload: True
        - require:
            - pkg: redis-server

/etc/redis/common.conf:
    file.managed:
        - source: salt://redis/files/common.conf
        - template: jinja
        - require:
            - pkg: redis-server

/etc/redis/redis.conf:
    file.absent:
        - require:
            - file: /etc/redis/common.conf

{% for server in pillar.get('redis', {}).get('servers', []) %}
/etc/redis/srv{{ server }}.conf:
    file.managed:
        - source: salt://redis/files/server.conf
        - template: jinja
        - context:
            server: {{ server }}
        - watch_in:
            - service: redis-server
        - require:
            - pkg: redis-server
{% endfor %}

/etc/init.d/redis-server:
    file.managed:
        - source: salt://redis/files/redis-server
        - mode: 755
        - watch_in:
            - service: redis-server
        - require:
            - pkg: redis-server

vm.overcommit_memory:
    sysctl.present:
        - value: 1
        - config: /etc/sysctl.d/10-redis.conf
