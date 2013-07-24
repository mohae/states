include:
    - nginx

php:
    pkg.installed:
        - pkgs:
            - php5-fpm
            - php5-cli
            - php5-common
            - php5-curl
            - php5-dev
            - php5-gd
            - php5-imagick
            - php5-mcrypt
            - php5-mysql
            - php5-memcache
            - php5-pspell
            - php5-suhosin
            - php5-snmp
            - php5-sqlite
            - php5-xmlrpc
            - php-apc
            - php-pear
        - require:
            - pkg: nginx
    service.running:
        - name: php5-fpm
        - enable: True
        - watch:
            - file: /etc/php5/conf.d/php.ini
            - file: /etc/php5/conf.d/apc.ini
        - reload: True
        - require:
            - pkg: php

/etc/php5/conf.d/php.ini:
    file.managed:
        - source: salt://php/files/php.ini
        - require:
            - pkg: php

/etc/php5/conf.d/apc.ini:
    file.managed:
        - source: salt://php/files/apc.ini
        - require:
            - pkg: php

{% for site, args in pillar.get('sites', {}).items() %}
{% if 'php' in args and args.php == True %}
/etc/php5/fpm/pool.d/{{ site }}.conf:
    file.managed:
        - source: salt://php/files/site.conf
        - template: jinja
        - context:
            site: {{ site }}
            args: {{ args }}
        - watch_in:
            - service: php
        - require:
            - pkg: php
{% else %}
/etc/php5/fpm/pool.d/{{ site }}.conf:
    file.absent:
        - require:
            - pkg: php
{% endif %}
{% endfor %}
